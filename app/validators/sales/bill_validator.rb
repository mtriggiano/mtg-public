module BillValidator
	extend ActiveSupport::Concern

	included do
    validates_presence_of  :entity_id,      message: "Debe especificar un receptor"
    validates_presence_of  :cbte_tipo,      message: "Debe especificar un tipo de comprobante"
    validates_inclusion_of :cbte_tipo,      message: "Tipo inválido", in: (Afip::CBTE_TIPO.keys + ["51", "52", "53"]).uniq
    validates_presence_of  :total_pay,      message: "Monto pagado inválido"
    validates_numericality_of :total_pay,   message: "Monto pagado inválido"
    validates_presence_of  :total_left,     message: "Monto faltante inválido"
    validates_numericality_of :total_left,  message: "Monto faltante inválido"
    validates_presence_of  :total,          message: "Monto total inválido"
    validates_numericality_of :total,       message: "Monto total inválido"
    #validates_presence_of  :sale_point,     message: "Debe especificar el punto de venta"
    validates_presence_of  :state,          message: "Debe especificar el estado"
    validates_inclusion_of :state,          message: "Estado inválido", in: ExpedientBill::STATES
    validates_presence_of :fch_vto_pago, if: Proc.new{|b| b.concept != "Productos"}
    validates_presence_of :fch_vto_pago, if: Proc.new{|b| b.concept != "Productos"}
    validates_presence_of :fch_ser_desde, if: Proc.new{|b| b.concept != "Productos"}
    validates_presence_of :fech_ser_hasta, if: Proc.new{|b| b.concept != "Productos"}
	  before_validation  :set_iva_cond, :set_default_cbte_tipo
	end

	def set_concept
    if self.class.name.demodulize == "SupplierBill"
      self.concept = "Productos"
    else
      if details.reject(&:marked_for_destruction?).map(&:is_a_product?).include?(false)
        if details.reject(&:marked_for_destruction?).map(&:is_a_service?).include?(false)
          self.concept = "Productos y Servicios"
        else
          self.concept = "Servicios"
        end
      else
        self.concept = "Productos"
      end
    end
  end

  def set_iva_cond
    self.iva_cond = entity.iva_cond unless entity.nil?
  end

  def set_default_cbte_tipo
    self.cbte_tipo ||= Afip::CBTE_TIPO.map{|k,v| v if Afip::AVAILABLE_TYPES[company.iva_cond_sym][entity.iva_cond_sym].include?(k)}.compact.first unless entity.nil?
  end

end
