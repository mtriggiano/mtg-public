class AgreementSurgeries::Shipment < ExpedientShipment
  belongs_to :file, class_name: "AgreementSurgeries::File"
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  validates_associated :details
  inherit_details_from :sale_order
  
  has_many :shipments_sale_orders, class_name: "AgreementSurgeries::ShipmentSaleOrder", foreign_key: :shipment_id, inverse_of: :shipment

  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shipments_sale_orders, reject_if: :all_blank, allow_destroy: true
  
  def has_pdf?
    true
  end

  def details_without_enough_stock
    details.select{ |detail| false }
  end

  def check_stock
    details.each{ |detail| detail.check_stock}
    childs.each{ |child| child.check_stock(self)}
  end

  def create_purchase_request
    current_request = purchase_request = nil
    if supplier_details_without_enough_stock.any?
      current_request = create_current_file_request
    end
    if own_details_without_enough_stock.any?
      purchase_request = create_purchase_file_request
    end

    return current_request, purchase_request
  end

  def create_current_file_request
    request = file.purchase_requests.build(
      user_id: user_id,
      company_id: company_id,
      init_date: Date.today,
      final_date: file.finish_date,
      request_type: "Solicitud de stock",
      observation: observation,
      state: "Pendiente",
      generated_by_system: true
    )
    request.purchase_requests_shipments.build(shipment_id: id)
    request.assign_details_from_shipment(self)
    request.current_user = current_user
    request.set_number
    request.save(validate: false)
    return request
  end

  def create_purchase_file_request
    p_file = create_purchase_file(file.title)
    request = p_file.purchase_requests.build(
      user_id: user_id,
      company_id: company_id,
      init_date: Date.today,
      final_date: file.finish_date,
      request_type: "Pedido de cirugía por convenio",
      observation: observation,
      state: "Pendiente",
      generated_by_system: true,
      external_file_id: file_id
    )
    request.assign_details_from_shipment(self)
    request.current_user = current_user
    request.set_number
    request.save(validate: false)
    return request
  end

  def create_purchase_file(title=nil)
    file = Purchases::File.new(
      company_id: company_id,
      user_id: current_user.id,
      title: "S.A - #{title}",
      init_date: Date.today,
      state: "En espera de presupuesto",
      description: "Generado automaticamente por el sistema debido a la falta de stock para el exp. de cirugía por convenio Nº #{self.file.number}",
      initial_department: Department.find_by_name("Compras").id
    )
    file.set_number
    file.generated_by_system = true
    file.save!
    return file
  end

  def supplier_details_without_enough_stock
    details.reject(&:marked_for_destruction?).select{ |detail| !detail.own? && detail.automatic_requested_quantity.to_f < detail.quantity}
  end

  def own_details_without_enough_stock
    result = []
    own_products.group_by(&:product_id).each do |id, dets|
      quantity  = dets.inject(0){|sum, h| sum + h.quantity}
      if dets[0].inventary.type == "Box"
        available_stock = quantity + 1
      else
        available_stock = dets[0].inventary.articles.sum(&:available)
      end
      if quantity > available_stock
        result <<
          {
            product_id: dets[0].product_id,
            product_name: dets[0].product_name,
            quantity: quantity - available_stock,
            product_measurement: dets[0].product_measurement,
            required: quantity,
            available: available_stock
          } unless dets.map(&:requested).include?("true")
      end
    end
    return result
  end

  def own_products
    (details.reject(&:marked_for_destruction?).select{ |detail| detail.own? && !detail.has_childs?} <<
    childs.joins(:detail).reject(&:marked_for_destruction?).select{ |child| child.own? }).flatten
  end
end