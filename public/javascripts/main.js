jQuery(function() {
  var $autofocus, $myModal;
  $autofocus = $('.autofocus');
  $autofocus.focus();
  $myModal = $('#myModal');
  $myModal.on('shown.bs.modal', function(e) {
    $(this).find('[name=user_id]').focus();
    return true;
  });
  $myModal.find('form').on('submit', function(e) {
    var $this, group;
    $this = $(this);
    group = $this.find('[name=user_password]').closest('.form-group');
    if (group.is('.has-error')) {
      alert('?!??!?');
      return false;
    }
    if ($this.find('[name=user_password]').val() !== $this.find('[name=user_pwreaffirm]').val()) {
      alert('?!??!?');
      return false;
    }
    return true;
  });
  $myModal.find('[name=user_password]').bind('keydown', function() {
    var $this, result;
    $this = $(this);
    result = zxcvbn($this.val(), [$('[name=user_id]').val()]);
    if (result.score < 2) {
      return $this.closest('.form-group').addClass('has-error').removeClass('has-success');
    } else {
      return $this.closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });
  $('[data-toggle~=confirm]').on('click', function(e) {
    if (confirm('정말로 지울래 말래?')) {
      return true;
    } else {
      e.preventDefault();
      return false;
    }
  });
  $('[data-toggle~=write_diary]').on('click', function() {
    var body;
    body = prompt('Body: ');
    if (body.trim().length === 0) {
      return alert('내용을 입력!');
    }
    return $.ajax({
      url: '/diary',
      type: 'post',
      data: {
        article: body
      },
      headers: {
        Accept: 'application/json'
      },
      success: function(data, status, xhr) {
        var $template;
        if (xhr.status !== 200) {
          return 'Error !';
        }
        console.log(data);
        $template = $('.item-template').clone();
        $template.find('p').html(body);
        $template.find('small').html('Last updated: ' + moment(data.date).format('lll'));
        $template.find('.edit').attr('href', '/edit/' + data._id);
        $template.find('.delete').attr('href', '/delete/' + data._id);
        $template.removeClass('hide');
        return $('#diary').append($template);
      },
      error: function(xhr, status, data) {
        return alert('Error: ' + status);
      }
    });
  });
  return true;
});
