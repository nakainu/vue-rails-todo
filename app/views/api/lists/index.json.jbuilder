json.set! :lists do
  json.array! @lists do |list|
    json.extract! list, :id, :name, :created_at, :updated_at
  end
end
