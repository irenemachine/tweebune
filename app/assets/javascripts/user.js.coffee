# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->
  client = new Faye.Client("http://localhost:9292/faye")
  subscription = null
  $("#fetch").bind "ajax:beforeSend", (event, xhr, settings) ->
    $("#tweets").empty()
    console.log subscription
    subscription.cancel()  unless subscription is null
    console.log subscription
    myregexp = /&user=.*(?=&)/
    name = myregexp.exec(settings.data)[0].slice(6)
    subscription = client.subscribe '/' + name, (data) ->
      $("<p>" + data + "</p>").hide().prependTo("#tweets").fadeIn("slow")
    console.log subscription

