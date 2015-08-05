if params[:user_id].blank?
    json.result_code 0
else
    json.result_code 1
    json.results @contents do |content|
        json.id content.id
        json.content_type content.content_type
        json.praise_num content.praise_num
        json.comment_num content.comment_num
        json.is_collect Collect.is_collect(content.id, params[:user_id])
        json.is_praise Praise.is_praise(content.id, params[:user_id])
        json.created_at content.created_at.strftime('%Y-%m-%d %H:%M:%S')
        json.updated_at content.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        json.title content.title
        json.content_abstract content.content[0,100]
        json.content content.content
        json.author content.author
        json.pic content.pic
    end
end


