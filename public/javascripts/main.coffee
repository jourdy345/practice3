jQuery ->
  $inputid = $ '.signin-body #inputID'
  $inputid.focus()

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
  true