json.result_code @result_code
json.result_msg @result_msg
if @user.present? && (@result_code == 1 || @result_code == 2)
    json.results do
        json.id @user.id
        json.idfa @user.idfa
        json.username @user.username
        json.nick @user.nick
        json.email @user.email
        json.avatar @user.avatar
        json.oauth_type @user.oauth_type
        json.uid  @user.uid
    end
end

