json.swap do
  json.id @swap.id
  json.requesting_user_id @swap.requesting_user_id
  json.accepting_user_id @swap.accepting_user_id
  json.shift_id @swap.shift_id
end