json.extract! @resource, :id
json.total_votes @resource.total_votes
json.vote_up_path vote_up_question_path(@resource)
json.vote_down_path vote_down_question_path(@resource)
