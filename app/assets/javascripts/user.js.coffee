# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('body').on 'click', 'a.news', ->
    $('#news').fadeIn()
    $('#analysis').hide()
    $('#tweets').hide()

  $('body').on 'click', 'a.analysis', ->
    $('#analysis').fadeIn()
    $('#news').hide()
    $('#tweets').hide()

  $('body').on 'click', 'a.tweets', ->
    $('#tweets').fadeIn()
    $('#news').hide()
    $('#analysis').hide()
