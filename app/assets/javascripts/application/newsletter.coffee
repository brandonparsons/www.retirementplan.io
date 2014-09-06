$ ->
  $(".JS-newsletter-form").on 'submit', (e) ->
    e.preventDefault()

    ga('send', 'event', 'conversion', 'newsletter')

    emailInput    = $(".JS-newsletter-email")
    submitButton  = $(".JS-newsletter-submit")

    submitButton.button('loading')

    $.ajax
      url: '/mailing_list_subscribe'
      type: 'POST'
      data: $(@).serialize()
      success: ->
        emailInput.val("")
        submitButton.button('reset')
        alert "Thanks! You have been signed up for the mailing list."
      error: (jqXHR) ->
        submitButton.button('reset')
        alert "Sorry - something went wrong signing you up for the mailing list. Please try again!"
