json.result_code @result_code
json.result_msg @result_msg
if @result_code.to_i == 1
  json.results do
    json.user_id params[:user_id]
    json.avatar @avatar
  end
end