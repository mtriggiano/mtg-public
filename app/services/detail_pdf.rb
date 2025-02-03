class DetailPdf
  attr_accessor :document, :with_childs
  def initialize(document, args={})
    @document = document
    @with_childs = args[:with_childs]
  end

  CUSTOM = [
    "Sales::Shipment",
    "Surgeries::Shipment",
    "Tenders::Shipment",
    "Sales::Order",
    "Surgeries::SaleOrder",
    "Tenders::Order",
    "Purchases::Order",
    "Surgeries::PurchaseOrder"
  ]

  def build
    response = []
    document_details = document.details#.includes(:inventary)
    document_details.each do |detail|
      response << to_hash_for_pdf(detail, document)
      detail.childs.each{|child| response << to_hash_for_pdf(child, document, true)} if with_childs
    end
    return response.flatten
  end

  def to_hash_for_pdf det, document, is_a_child=false
    if det.respond_to?(:batches) && det.batches.any?
      traceable_detail(det, is_a_child)
    else
      no_traceable_for_pdf(det, is_a_child)
    end
  end

  def traceable_detail detail, is_a_child
    detail.batch_details.map do |d|
      {
        'tipo' => is_a_child ? "child" : "parent",
        'price' => detail_with_currency(detail, "price", is_a_child),
        'bonus_amount' => detail_with_currency(detail, "bonus_amount", is_a_child),
        'discount' => detail.respond_to?(:discount) && !is_a_child ? detail.try(:discount) : nil,
        'iva' => detail.respond_to?(:iva_aliquot) && !is_a_child ? detail.try(:iva) : nil,
        'iva_aliquot' => detail.respond_to?(:iva_aliquot) && !is_a_child ? detail.try(:iva_aliquot) : nil,
        'iva_amount' => detail_with_currency(detail, "iva_amount", is_a_child),
        'total' => detail_with_currency(detail, "total", is_a_child),
        'product_code' => detail.respond_to?(:product_code) ? detail.try(:product_code) : nil,
        'return_reason' => detail.respond_to?(:return_reason) ? detail.try(:return_reason) : nil,
        'pm' => detail.respond_to?(:pm) ? detail.try(:inventary).try(:pm) : nil,
        'branch' => detail.try(:branch),
        'source' => detail.try(:source),
        'code' => d.batch.try(:code),
        'serial' => d.batch.try(:serial),
        'due_date' => d.batch.try(:due_date),
        'product_name' => detail.respond_to?(:product_name) ? detail.try(:product_name) : nil,
        'product_measurement' => detail.respond_to?(:product_measurement) ? detail.try(:product_measurement) : nil,
        'quantity' => d.quantity,
        'return_reason' => detail.respond_to?(:return_reason) ? detail.try(:return_reason) : nil
      }
    end
  end

  def no_traceable_for_pdf detail, is_a_child
    {
      'tipo' => is_a_child ? "child" : "parent",
      'price' => detail_with_currency(detail, "price", is_a_child),
      'bonus_amount' => detail_with_currency(detail, "bonus_amount", is_a_child),
      'discount' => detail.respond_to?(:discount) && !is_a_child ? detail.try(:discount) : nil,
      'iva' => detail.respond_to?(:iva_aliquot) && !is_a_child ? detail.try(:iva) : nil,
      'iva_aliquot' => detail.respond_to?(:iva_aliquot) && !is_a_child ? detail.try(:iva_aliquot) : nil,
      'iva_amount' => detail_with_currency(detail, "iva_amount", is_a_child),
      'total' => detail_with_currency(detail, "total", is_a_child),
      'product_code' => detail.respond_to?(:product_code) ? detail.try(:product_code) : nil,
      'pm' => detail.respond_to?(:pm) ? detail.try(:inventary).try(:pm) : nil,
      'branch' => detail.try(:branch) || detail.product.try(:branch),
      'source' => detail.try(:source),
      'code' => nil,
      'serial' => nil,
      'due_date' => nil,
      'product_name' => detail.respond_to?(:product_name) ? detail.try(:product_name) : nil,
      'product_measurement' => detail.respond_to?(:product_measurement) ? detail.try(:product_measurement) : nil,
      'quantity' => detail.respond_to?(:approved_quantity) ? detail.try(:approved_quantity) : (detail.respond_to?(:quantity) ? detail.try(:quantity) : nil),
      'return_reason' => detail.respond_to?(:return_reason) ? detail.try(:return_reason) : nil,
      'own' => detail.try(:product).try(:own) ? 'Propio' : 'Consignado',
      'supplier' => detail.respond_to?(:supplier) ? detail.supplier.try(:name) : nil
    }
  end

  def detail_with_currency detail, attribute, is_a_child=false
    document = detail.parent
    unless document.nil?
      calc = eval("detail.respond_to?(:#{attribute})") && !is_a_child ? eval("detail.try(:#{attribute})") : nil
      currency = document.try(:currency) || "ARS"
      return calc
      # if currency == "USD"
      #   #usd_price = document.try(:usd_price) || 1.0
      #   unless calc.nil?
      #     return (calc).to_f.round(2)
      #   else
      #     return nil
      #   end
      # else
      #   return calc
      # end
    end
  end

end
