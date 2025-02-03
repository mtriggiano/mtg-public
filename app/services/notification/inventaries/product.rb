class Notification::Inventaries::Product < NotificationMaker

  def for_minimum_stock
    product = document
    title = "Producto con stock por debajo del mínimo"
    body = "El producto #{product.code} - #{product.name} tiene stock disponible: #{product.available_stock}, lo cual es por debajo del stock mínimo (#{product.minimum_stock})"
    unless users.nil?
			users.each do |user_id|
        user = User.find(user_id)
				notifications << build(title, body, product, user_id, "danger", user.company_id)
			end
			send_notification(notifications)
		end
  end

  def for_recommended_stock
    product = document
    title = "Producto con stock por debajo del recomendado"
    body = "El producto #{product.code} - #{product.name} tiene stock disponible: #{product.available_stock}, lo cual es por debajo del stock recomendado (#{product.recommended_stock})"
    unless users.nil?
			users.each do |user_id|
        user = User.find(user_id)
				notifications << build(title, body, product, user_id, "info", user.company_id)
			end
			send_notification(notifications)
		end
  end

end
