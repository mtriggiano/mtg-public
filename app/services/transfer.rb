class Transfer

	def initialize(note)
		@note = note
		@store = note.store
	end


	def make
		if @note.saved_change_to_state?
			case @note.state
			when "Pendiente"
				#RESERVAR STOCK LOCAL
				reserve
			when "Enviado"
				#DESCONTAR STOCK RESERVADO Y AUMENTAR STOCK ENVIADO LOCAL
				move(:reserved, :sended, :local)
				#REGISTRAR ENVIO EN BANCO
				set_activity("El stock de reposición se encuentra en camino.", "send")
			when "Recibido"
				#DESCONTAR STOCK ENVIADO LOCAL Y AUMENTAR STOCK DISPONIBLE EXTERNO
				move(:sended, :available, :external)
				#REGISTRAR RECEPCION EN BANCO
				set_activity("El stock de reposición se encuentra en el banco.", "receive")
				#VERIFICAR 
					#SI CUMPLE CON STOCK MINIMO CAMBIAR ESTADO A FINALIZADO
					unless cumpliment_minimum_stock?
						#SI NO CUMPLE GENERAR ALERTA
						#TODO make_alert
					end
			when "Anulado"
				#VERIFICAR QUE ESTADO PREVIO SEA "PENDIENTE" O. "ENVIADO", CASO CONTRARIO AÑADIR ERROR
				#SI EL ESTADO PREVIO ES PENDIENTE
					#ELIMINAR STOCK RESERVADO Y AUMENTAR STOCK DISPONIBLE LOCAL
				#SI EL ESTADO PREVIO ES ENVIADO
					#DESCONTAR STOCK ENVIADO Y AUMENTAR STOCK DISPONIBLE LOCAL
					#REGISTRAR ANULACION DE ENVIO EN EL BANCO
			end
		end
	end

	def details
		@note.details
	end

	def reserve
		details.each do |detail|
			::Inventary.new(detail.product, detail.quantity, from_store: detail.store).reserve
		end
	end

	def move(from, to, transfer_type)
		details.each do |detail|
			if transfer_type == :local
				#UTILIZADO PARA TRANSFERENCIAS DE ESTADOS EN UN MISMO BANCO
				::Inventary.new(detail.product, detail.quantity, from: from, to: to, from_store: detail.store).transfer
			else
				# UTILIZADO PARA TRANSFERENCIAS ENTRE BANCOS
				::Inventary.new(detail.product, detail.quantity, from: from, to: to, from_store: detail.store, to_store: @store).transfer
			end
		end
	end

	def cumpliment_minimum_stock?
		cumpliment = true
		details.each do |detail|
			inventary = detail.product.stocks.where(store_id: @store.id).first_or_create 
			cumpliement = inventary.available == inventary.minimum_available
			break unless cumpliment
		end
		return cumpliment
	end

	def set_activity(text, activity_type)
		details.group_by{|detail| detail.store_line unless detail.store_line.nil?}.each do |line, details|
			act = line.activities.create(
				name: text,
				link: "/transfer_notes/#{@note.id}",
				date: Date.today,
				user_id: @note.user_id,
				activity_type: activity_type
			)
		end
	end
end