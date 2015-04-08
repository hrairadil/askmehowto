json.extract! @answer, :id, :body, :best
json.user @answer.user, :id, :email
json.current_user_id current_user.id

json.attachments @answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
  json.path attachment_path(a)
end