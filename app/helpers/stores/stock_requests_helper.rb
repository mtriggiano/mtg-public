module Stores::StockRequestsHelper

	def state_buttons request
		unless request.new_record?
			external_id = request.store_line.store_id
			content_tag :div do
				case request.state
				when "Solicitado"
						#SI ESTA SOLICITADO SOLAMENTE PUEDE APROBARLO O RECHAZARLO
						concat(link_to "#{icon('fas', 'check')} Aprobar".html_safe, change_state_stores_stock_request_path(request.id, external_id: external_id,state: "Aprobado"), method: :patch, data: {confirm: "Esta por cambiar el estado de todos los detalles asociados. ¿Desea continuar?"}, class: 'btn btn-success mr-2')
						concat(link_to "#{icon('fas', 'times')} Rechazar".html_safe, change_state_stores_stock_request_path(request.id, external_id: external_id,state: "Rechazado"), method: :patch, data: {confirm: "Esta por cambiar el estado de todos los detalles asociados. ¿Desea continuar?"}, class: 'btn btn-warning ml-2')
				when "Aprobado"
					#SI ESTA APROBADO SOLAMENTE PUEDE ENTREGARLO
					link_to "#{icon('fas', 'share')} Entregar".html_safe, change_state_stores_stock_request_path(request.id, external_id: external_id,state: "Entregado"), method: :patch, data: {confirm: "Esta por cambiar el estado de todos los detalles asociados. ¿Desea continuar?"}, class: 'btn btn-primary'
				when "Entregado"
					link_to "#{icon('fas', 'minus')} Anular".html_safe, change_state_stores_stock_request_path(request.id, external_id: external_id,state: "Anulado"), method: :patch, data: {confirm: "Esta por cambiar el estado de todos los detalles asociados. ¿Desea continuar?"}, class: 'btn btn-danger'
				end
			end
		end
	end
end
