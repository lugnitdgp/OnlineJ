  document.addEventListener 'turbolinks:load', (event) ->
  if typeof ga is 'function'
    userId = $('#user').text().split(" ")[2];
    if userId == undefined
       userId = "anonymous"
    ga('set', 'location', location.pathname)
    ga('set', 'userId', userId);
    ga('send', 'pageview',{ "title": document.title })
