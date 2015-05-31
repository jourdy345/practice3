jQuery(function() {
  var $inputid, $myModal;
  $inputid = $('.signin-body #inputID');
  $inputid.focus();
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
  return true;
});
