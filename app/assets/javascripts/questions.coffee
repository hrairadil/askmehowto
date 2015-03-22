# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  questionReady = ->
    $('.edit-question-link').click (e) ->
      e.preventDefault()
      $(this).hide()
      $('form#edit-question').show()
  $(document).ready(questionReady)
  $(document).on('page:load', questionReady)