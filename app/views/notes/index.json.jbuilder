json.notes @notes do |note|
  json.note_id note.id
  json.user_id note.user_id
  json.user_name note.user.name
  json.date note.date
  json.text note.text
end