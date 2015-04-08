# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  editAnswer = (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("form#edit-answer-#{answer_id}").show()

  $(document).on 'click', '.edit-answer-link', editAnswer

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(JST["templates/answer"]({answer: answer}))
    $('#create-answer-body').val('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    $('.answer-errors').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)
