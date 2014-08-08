testForGALoaded = ->
  # If the user is blocking google analytics (i.e. through Ghostery), we don't
  # want to set a blocking click handler on links.
  ga 'send', 'event', 'testGALoaded', 'testEvent',
    nonInteraction: 1,
    hitCallback: ->
      if typeof(window.console) != 'undefined' && (window.console != null)
        window.console.log "Received GA callback. Setting click handler"
      setEventHandler()


setEventHandler = ->
  $('body').on 'click', 'a', (e) ->
    url = $(@).attr('href')

    if isSignupLink(url)
      e.preventDefault()
      trackSignupConversion(url)
    else if isExternalLink(url)
      e.preventDefault()
      trackOutboundLink(url)
    else # Internal link, non signup.
      e.preventDefault()
      trackInternalLink(url)


isSignupLink = (url) ->
  return /^(.*)\/sign_up/.test(url)


isExternalLink = (url) ->
  hostname = new RegExp(location.host)

  if hostname.test(url) # Test if current host (domain) is in it - if so, it is internal
    return false
  else if url.slice(0, 1) == '/' # Starts with '/' - internal
    return false
  else if url.slice(0, 1) == '#' # It is an anchor link
    return false
  else # A link that does not contain the current host - external!
   return true


trackSignupConversion = (url) ->
  ga 'send', 'event', 'conversion', 'signup',
    hitCallback: ->
      document.location = url


trackOutboundLink = (url) ->
  ga 'send', 'event', 'externalLink', 'click', url,
    nonInteraction: 1,
    hitCallback: ->
      window.open(url, '_blank')

trackInternalLink = (url) ->
  ga 'send', 'event', 'internalLink', 'click', url,
    hitCallback: ->
      document.location = url

$ ->
  testForGALoaded()
