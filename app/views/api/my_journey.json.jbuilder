json.result_code @result_code
json.result_msg @result_msg
if @result_code.to_i == 1
  json.results do
    json.collect_num @collect_num
    json.comment_num @comment_num
    json.praise_num @praise_num
  end
end