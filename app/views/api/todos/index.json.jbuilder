json.set! :todos do
  json.array! @todos do |todo|
    json.extract! todo, :id, :name, :is_done, :deadline, :created_at, :updated_at, :list_id
  end
end
