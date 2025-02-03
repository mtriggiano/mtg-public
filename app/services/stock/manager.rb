
module Stock
	class Manager

		def initialize(opts={})
			@detail 			= opts[:detail]
			@product 			= opts[:product] || @detail.inventary || @detail.errors.add(:base, "Debe especificar un producto")
			@batches			= opts[:batches] || @detail.try(:batches)
			@mode = opts[:mode] || "regular"
			if @detail
				@store 				= @detail.store
				@article 			= @product.articles.where(store_id: @store.id).first_or_create if @product.is_a_product?
				@detail.need_to_remove_stock = false
			end
			@product.reload
		end

		def self.search_product_or_create(company, name)
			product = company.inventaries.where(name: name).first_or_initialize
			if product.new_record?
				product.product_category_id = company.product_categories.where(name: "Generados por el sistema").first_or_create.id
				product.measurement_unit = "7"
				product.product_type = "regular"
				product.type = "Product"
				product.save
			end
			return product
		end

		def has_stock?(store_id = nil)
			@product.articles.where(store_id: @store.id).sum(:available) > 0
		end

		def has_enough_stock?(quantity, store_id=nil)
			return true if @product.is_a_box?
			if store_id.nil?
				return @product.available_stock >= quantity
			else
				return @product.articles.where(store_id: store_id).sum(:available) >= quantity
			end
		end

		def available_batches
			@product.batches.where(state: true)
		end

		def manage_stock_alert
		  if @product.available_stock <= @product.recommended_stock
				if @product.available_stock <= @product.minimum_stock
					Notification::Inventaries::Product.new(@product, nil, User.joins(:work_station).where(work_stations: {name: "EMPLEADO DE ALMACEN"}).ids).for_minimum_stock
				else
					Notification::Inventaries::Product.new(@product, nil, User.joins(:work_station).where(work_stations: {name: "EMPLEADO DE ALMACEN"}).ids).for_recommended_stock
				end
			end
		end

		def available_stock(store_id = nil)
			if store_id.nil?
				@product.batches.sum(:available)
			else
				Batch.joins(arrival_detail: :arrival)
					.where(arrival_detail: {product_id: @product.id}, arrival: {store_id: store_id})
					.sum
			end
		end

		def add_stock(quantity, mode = :regular)
			# revive_batches crea y actualiza los LOTES
			# article: actualzia el stock del producto total en el deposito
			#  TODO: una relacion, entre esos lotes y el deposito
			fill_batches("check_in") if (@detail.batch_details.blank? && @mode == "regular")
			revive_batches
			if @detail.valid? && @product.is_a_product?
				@article.update(available: @article.available + @detail.quantity)
				@article.freeze
				manage_stock_alert
			end
		end

		# store: deposito_central 20 unidades
		# quiero registrar una salida, te declaro deposito_central
		    # en la trazabilidad, lote 1-1, 10
		
		# prod, lote, seria, stock 2, vencimiento, deposito_san_b
			#batch.stock += stock
			#batch.vencimiento = vencimiento
			#batch.stores = [
				#{  store: deposito_san_b, cantidad: 2}
			#]
		## prod, lote, seria, stock 1, vencimiento, deposito_central
			#batch.stock += stock
			#batch.vencimiento = vencimiento
			#batch.stores = [
				#{ store: deposito_san_b, cantidad: 2},
				#{ store: deposito_central, cantidad: 1}
			#]
#
			#product = {
				#nombre: "cinta de algo",
				#available_stock: 11
				#batches: [
					#batch(
						#serie: 1, lote: 123,
						#stock: 5,
						#stores: [
							#{ store: deposito_san_b, cantidad: 2},
							#{ store: deposito_central, cantidad: 1},
							#{ store: deposito_tucuman, cantidad: 1},
						#]
					#),
					#batch(
						#serie: 123, lote: 11,
						#stock: 3,
						#stores: [
							#{ store: deposito_san_b, cantidad: 1},
							#{ store: deposito_central, cantidad: 1},
							#{ store: deposito_tucuman, cantidad: 1},
						#]
					#)
					#batch(
						#serie: 222, lote: 11,
						#stock: 3,
						#stores: [
							#{ store: deposito_san_b, cantidad: 0},
							#{ store: deposito_central, cantidad: 3},
							#{ store: deposito_tucuman, cantidad: 0},
						#],
						#batch_details: [
							#{
								#detail: "Remito de cirujias"
								#cantidad: 1
								#store_id: deposito_central
							#},
							#{
								#detail: "Arrivo de almacen"
								#cantidad: 4
								#store_id: deposito_central
							#}
						#]
					#)
				#]
			#}
#
			#La gente descargo un report desde el sistema, donde tienen todos los lotes que existen hoy
			#- si esos lotes no tiene stock, los van a dejar en cero 
			#- por lo tanto, cuando yo importe el excel, debo pisar el stock. 
			#- solo debo agregar o asociar batch a stores
				#- con este objeto { store: deposito_tucuman, cantidad: 1},
			#- una vez aue termine de importar todo, recalcular el stock de cada batch, y el stock total del product
			#- crear la relacion, y crear la vista para mostrar
			#- el batch detail deberia tener tambien el store_id del cual se agrega o saca productos 
			#- implementar la logica en el stock manager.	

		def remove_stock(quantity, mode = :regular)
			return true unless @product.is_a_product?
			#fill_batches("check_out") if (@detail.batch_details.blank? && @mode == "regular")
			disable_batches
			if @detail.valid?
				raise StandardError.new("Stock Insuficiente") unless @article.update(available: @article.available - @detail.quantity)
				@article.freeze
				manage_stock_alert
			end
		end

		def set_consumption
			return true unless @product.is_a_product?
			available_stock = @article.available + (@detail.sended_quantity - @detail.quantity)
			@article.update(available: available_stock)
			change_consumption(state: true)
		end

		def unset_consumption
			return unless @product.is_a_product?
			available_stock = @article.available - (@detail.sended_quantity - @detail.quantity)
			@article.update(available: available_stock)
			change_consumption(state: false)
		end

		def change_consumption args={}
			@detail.batches.reload
			return true unless @product.respond_to?(:batches)
			current_batch_details = {}
			@detail.batch_details.each{|bd| current_batch_details[bd.batch_id] = bd.quantity }
			
			@detail.shipment_details.each do |shipment_detail|
				shipment_detail.batch_details.each do |bd|
					batch = bd.batch
					if args[:state]
						new_quantity = bd.quantity - current_batch_details[bd.batch_id].to_f #1
						bd.update_column(:returned, new_quantity)
					else
						new_quantity = -(bd.quantity - current_batch_details[bd.batch_id].to_f)
						bd.update_column(:returned, 0)
					end
					unless batch.nil?
						batch.quantity = batch.quantity + new_quantity
						batch.increase_batch_stores(@store, new_quantity)
						batch.state = batch.quantity > 0
						batch.save
					end
				end
			end
			manage_stock_alert
		end

		# Si no se selecciona nada en la trazabilidad de los detalles de entrada, se lo agrega al lote por defecto.
		def fill_batches modo="check_in"
			pp modo
		  pp sn_batch = @product.try(:default_batch)
			unless sn_batch.nil?
				if modo == "check_out"
					if sn_batch.quantity >= @detail.quantity
						bd = @detail.batch_details.where(batch_id: sn_batch.id).first_or_initialize
						bd.quantity = @detail.quantity
						bd.save
					else
						raise StandardError.new("EL lote S/N del detalle #{@detail.inventary&.name} no tiene stock.")
					end
				else
					bd = @detail.batch_details.where(batch_id: sn_batch.id).first_or_initialize
					bd.quantity += @detail.quantity
					bd.save
				end
			else
				@detail.errors.add(:batch, "Imposible crear el lote S/N")
			end
		end

		# Metodo encargado de decrementar stock en los lotes que se definen en la trazabilidad
		# Si no se define nada en la trazabilidad, se decrementa el lote por defecto S/N
		def disable_batches
			to_update = {}
			@detail.batch_details.each do |batch_detail|
				batch_detail.updated_at = Time.now
				batch = batch_detail.try(:batch) || @detail.product.try(:default_batch)
				batch.product = @detail.product
				batch_detail.batch = batch
				to_update[batch] ||= 0
				to_update[batch] += batch_detail.quantity
			end
			to_update.each do |batch, quantity|
				batch.reload
				batch.quantity = batch.quantity - quantity
				batch.decrease_batch_stores(@store, quantity)
				batch.product_id = @detail.product_id
				batch.state = batch.quantity > 0
				batch.save!
			end
		end

		# Metodo encargado de incrementar  stock en los lotes que se definen en la trazabilidad
		# Si no se define nada en la trazabilidad, se incrementa el lote por defecto S/N
		def revive_batches
			@detail.batch_details.each do |batch_detail|
				batch_detail.updated_at = Time.now
				batch = @detail.product.batches.where(serial: batch_detail.batch.serial, code: batch_detail.batch.code).first rescue nil
				batch ||= batch_detail.try(:batch)
				batch ||= @detail.product.try(:default_batch)
				
				batch.product_id ||= @detail.product_id
				batch.quantity += batch_detail.quantity
				batch.state = batch.quantity > 0
				batch_detail.batch = batch
				batch.increase_batch_stores(@store, batch_detail.quantity)
				batch.save!
				batch_detail.save!
			end

			# Si el detalle indica una cantidad mayor a la definida en la trazabilidad
			# agrega la cantidad faltante al lote por defecto S/N
			total = @detail.batch_details.pluck(:quantity).sum
			if total < @detail.quantity && @detail.valid? && @product.is_a_product?
				batch = @detail.product.default_batch
				quantity = @detail.quantity - total
				batch_detail = @detail.batch_details.new(
					batch: batch, 
					quantity: quantity
				)
				batch.quantity += batch_detail.quantity
				batch.increase_batch_stores(@store, batch_detail.quantity)
				batch.state = batch.quantity > 0
				batch.save!
				batch_detail.save!
			end
		end

		def delete_batches
			result = {}
			@batches.each_with_index do |batch, index|
				result[index] = {:id => batch.id, :_destroy => true}
			end
			@detail.batches_attributes = result
		end
	end

end
