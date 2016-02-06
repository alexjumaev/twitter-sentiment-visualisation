

removeWords = require 'remove-words'

makeClickWords = (body) ->
  clWord = (word) -> (''+word).toLowerCase().replace /\W/g, ''
  clickWords = removeWords body # Array of keywords
  htmlTweet = ''
  aStyle = 'style="color: black; font-weight: bold;" ' # style for hyperlinks
  for word in body.split " "
    if clWord(word) in clickWords
      htmlTweet += "<a #{aStyle} href='/text-tweets/#{clWord word}'>#{word}</a> "
    else htmlTweet += "#{word} "
  htmlTweet

makeDiv = (tweet) ->
  col = if tweet.sentiment > 0 then 'green' else 'darkred'
  html = "<div class='card-panel'>"
  html += "<div class='pull-right'>"
  html += "<b style='color: #{col}'>#{tweet.sentiment*100}%</b>"
  html += "</div>"
  html += "#{makeClickWords tweet.body}"
  if tweet.location.place_name != null
    html += "<br><i class='tiny material-icons small-grey'>location_on</i>"
    html += "<p class='small-grey inline'>#{tweet.location.place_name}</p>"
  html += "</div>"
  html

if searchTerm == ''

  socket = io.connect('http://localhost:8080');

  socket.on 'anyTweet', (tweetObj) ->

    if $('#showLive').is(':checked')

      if tweetObj.sentiment > 0
        $("#positiveContainer").prepend(makeDiv tweetObj)
        $('#positiveContainer .card-panel:last').remove()

      else if tweetObj.sentiment < 0
        $("#negativeContainer").prepend(makeDiv tweetObj)
        $('#negativeContainer .card-panel:last').remove()

