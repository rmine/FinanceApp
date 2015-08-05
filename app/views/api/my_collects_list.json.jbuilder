if params[:user_id].blank?
  json.result_code 0
else
  json.result_code 1
  json.results @collects do |collect|
    json.id collect.content.id
    json.content_type collect.content.content_type
    json.praise_num collect.content.praise_num
    json.comment_num collect.content.comment_num
    json.created_at collect.content.created_at.strftime('%Y-%m-%d %H:%M:%S')
    json.content collect.content.content
    json.content_abstract collect.content.content[0,100]
    json.pic collect.content.pic
    json.title collect.content.title
    json.author collect.content.author
    json.is_collect Collect.is_collect(collect.content.id, params[:user_id])
    json.is_praise Praise.is_praise(collect.content.id, params[:user_id])
    json.created_at collect.content.created_at.strftime('%Y-%m-%d %H:%M:%S')
    json.updated_at collect.content.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    json.collect_created_at collect.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end  

