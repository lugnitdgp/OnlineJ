  document.addEventListener 'turbolinks:load', (event) ->
  if typeof ga is 'function'
    ga('set', 'location', location.pathname)
    ga('send', 'pageview',{ "title": document.title })
