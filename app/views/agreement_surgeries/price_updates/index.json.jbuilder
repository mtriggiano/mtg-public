json.set! :data do
  json.array! @price_updates do |price_update|
    json.partial! 'price_updates/price_update', price_update: price_update
    json.url  "
              #{link_to 'Show', price_update }
              #{link_to 'Edit', edit_price_update_path(price_update)}
              #{link_to 'Destroy', price_update, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end