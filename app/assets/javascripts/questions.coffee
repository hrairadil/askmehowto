# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  questionReady = ->
    $('.edit-question-link').click (e) ->
      debugger
      e.preventDefault()
      $(this).hide()
      question_id = $(this).data('questionId')
      $("form#edit-question-#{question_id}").show()
  $(document).ready(questionReady)
  $(document).on('page:load', questionReady)