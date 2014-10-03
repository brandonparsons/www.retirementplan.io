$ ->

  $(".JS-plan-button").on 'click', (e) ->
    e.preventDefault()
    $link = $(@)
    desiredPlan = $link.attr('id').match(/^(.+)-plan$/)[1] # basic, standard or premium
    window.__DESIREDPLAN__ = desiredPlan
    $("#JS-email-collection-modal").modal()

  $("#JS-email-collection-modal-form").on 'submit', (e) ->
    e.preventDefault()
    providedEmail = $("#JS-email-input").val()

    $.ajax
      url: '/mailing_list_subscribe'
      type: 'POST'
      data: $(@).serialize()
      success: ->
        $("#JS-email-input").val("")
        desiredPlan = window.__DESIREDPLAN__
        window.__DESIREDPLAN__ = null
        window.location.href = "/thanks?from=signup&plan=#{desiredPlan}"
      error: (jqXHR) ->
        alert "Sorry - something went wrong signing you up for the mailing list. Please try again!"
