json.extract! @answer, :id, :question_id, :body, :best
json.user @answer.user, :id, :email
json.current_user_id current_user.id
json.path answer_path(@answer)

json.total_votes @answer.total_votes
json.vote_up_path vote_up_answer_path(@answer)
json.vote_down_path vote_down_answer_path(@answer)
json.voted_by_current_user? @answer.voted_by?(current_user)


json.attachments @answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
  json.path attachment_path(a)
end
