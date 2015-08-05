if params[:content_id].blank?
  json.result_code 0
else
  json.result_code 1
  json.left_amount @left_amount
  json.results @comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.content_id comment.content_id
    json.user_id comment.user_id
    json.nick comment.user.nick
    json.avatar comment.user.avatar
    json.created_at comment.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end  

