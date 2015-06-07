jQuery ->
  $autofocus = $ '.autofocus'
  $autofocus.focus()

  $myModal = $ '#myModal'
  $myModal
    .on 'shown.bs.modal', (e) ->
      $ this
        .find '[name=user_id]'
        .focus()
      true
    $myModal.find 'form'
      .on 'submit', (e) ->
        $this = $ this
        # if $this.find('[name=user_id]').val()?.length < 3
        #   alert '?!??!?'
        #   return false
        group = $this.find('[name=user_password]').closest '.form-group'
        if group.is '.has-error'
          alert '?!??!?'
          return false
        if $this.find('[name=user_password]').val() isnt $this.find('[name=user_pwreaffirm]').val()
          alert '?!??!?'
          return false

        true
  $myModal.find '[name=user_password]'
    .bind 'keydown', ->
      $this = $ this
      # check
      result = zxcvbn $this.val(), [
        $('[name=user_id]').val()
      ]
      # .has-error
      if result.score < 2
        $this.closest '.form-group'
          .addClass 'has-error'
          .removeClass 'has-success'
      else
        $this.closest '.form-group'
          .removeClass 'has-error'
          .addClass 'has-success'

  $ '[data-toggle~=confirm]'
    .on 'click', (e) ->
      if confirm '정말로 지울래 말래?'
        return true
      else
        e.preventDefault()
        return false
  
  $ '[data-toggle~=write_diary]'
    .on 'click', ->
      body = prompt 'Body: '
      # validation
      if body.trim().length is 0
        return alert '내용을 입력!'

      # send
      $.ajax
        url: '/diary'
        type: 'post'
        data:
          article: body
        headers:
          Accept: 'application/json'
        success: (data, status, xhr) ->
          if xhr.status isnt 200
            return 'Error !'

          # add it to this page
          console.log data
          # console.log status
          # console.log xhr
          $template = $('.item-template').clone()
          $template
            .find 'p'
            .html body
          
          $template
            .find 'small'
            .html 'Last updated: ' + moment(data.date).format('lll')

          $template
            .find '.edit'
            .attr 'href', '/edit/'+data._id
          
          $template
            .find '.delete'
            .attr 'href', '/delete/'+data._id
          
          $template.removeClass 'hide'

          $('#diary').append $template
            
        error: (xhr, status, data) ->
          alert 'Error: '+ status

  true