json.extract! @resource, :id
json.total_votes @resource.total_votes
json.voted_by_current_user? @resource.voted_by?(current_user)
json.vote_up_path vote_up_question_path(@resource)
json.vote_down_path vote_down_question_path(@resource)
