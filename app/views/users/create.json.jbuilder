json.user do
    json.api_token @user.api_token
    json.id @user.id
    json.name @user.name
    json.email @user.email
    json.phone_number @user.phone_number
end
