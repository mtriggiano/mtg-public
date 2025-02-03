class Surgeries::FileVencidosPresenter < Sales::FilePresenter
  presents :file

  def sale_order_date
    debugger if file.id == 15
    file.sale_orders.last&.read_attribute(:expected_delivery_date) 
  end 

  def surgical_sheet
    link_to file.surgical_sheet_original_filename, file.surgical_sheet unless file.surgical_sheet == "/images/attachment.png"
  end  
    
  def implant_certificate
    link_to file.implant_original_filename, file.implant_certificate unless file.implant_certificate == "/images/attachment.png"
  end

  def expedient_title
    link_to file.title, file
  end
  
  def expedient_state
    file.state
  end

  def seller
    file.sale_orders.map{|sale_order| sale_order.sellers.uniq }.flatten.uniq.map{|seller| link_to seller.name, seller }.join(", ").html_safe
  end

  def place
    file.place
  end

  def vencido
    if file.cx_notificacions.present?
      "No"
    else
      "Si"
    end
  end

  def action_links
    mensaje_boton = file.cx_notificacions.present? ? "Marcar como Vencido" : "Marcar como NO Vencido"
    mensaje_confirmacion = "¿Estás seguro de que quieres #{mensaje_boton}?"
    content_tag :div do
      concat(link_to_edit(excluir_de_vencidos_surgeries_file_path(file), method: :put, title: mensaje_boton, data: { confirm: mensaje_confirmacion }))
      concat(
        link_to_cutom(surgeries_file_new_cambiar_seller_path(file), 'fas', 'user', method: :get, title: "Cambiar Vendedor")
      )
		end
  end
end
