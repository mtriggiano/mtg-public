json.extract! price_update, :id, :percent, :created_by_id, :log, :created_at, :updated_at
json.url price_update_url(price_update, format: :json)
