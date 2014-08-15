setEventHandler = ->
  # This may not be able to fire to Google Analytics on time, but was having
  # compatibility issues when trying to force preventDefault first, tracking,
  # then allowing page change.  Just do our best (for now).
  $('body').on 'click', 'a', (e) ->
    url = $(@).attr('href')

    if !url?
      trackInternalLink("href-null-false")
    else if isExternalLink(url)
      trackOutboundLink(url)
    else # Internal link
      trackInternalLink(url)

    return true

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

trackOutboundLink = (url) ->
  ga 'send', 'event', 'externalLink', 'click', url, nonInteraction: 1
  return true

trackInternalLink = (url) ->
  ga 'send', 'event', 'internalLink', 'click', url
  return true

$ ->
  setEventHandler()
