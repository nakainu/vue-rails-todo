json.set! :todo do
  json.extract! @todo, :id, :name, :is_done, :created_at, :updated_at, :list_id
end
