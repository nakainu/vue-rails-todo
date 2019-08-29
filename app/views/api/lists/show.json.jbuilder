json.set! :list do
  json.extract! @list, :id, :name, :created_at, :updated_at
end
