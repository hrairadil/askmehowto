json.extract! @resource, :id, :question_id
json.total_votes @resource.total_votes
json.vote_up_path vote_up_question_answer_path(@resource.question, @resource)
json.vote_down_path vote_down_question_answer_path(@resource.question, @resource)
