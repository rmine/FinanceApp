json.result_code @result_code
json.result_msg @result_msg
if @user.present? && @result_code == 1
    json.results do
        json.id @user.id
        json.idfa @user.idfa
        json.username @user.username
        json.nick @user.nick
        json.avatar @user.avatar
        json.email @user.email
    end
end

