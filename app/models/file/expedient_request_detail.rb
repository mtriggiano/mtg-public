class ExpedientRequestDetail < ApplicationRecord
    self.table_name = :request_details
    #include ProductInheritance
	  include Virtus.model(constructor: false, mass_assignment: false)
    STATES = ExpedientRequest::STATES

    attribute :current_user, User
    store_accessor :custom_attributes, :supplier_price
    validate :check_permissions
    include ProductDetails
    before_validation :set_childs_current_user
    after_initialize :set_type

    TABLE_COLUMNS = {
      "" =>                     {"important" => false,  "fixed" => false},
      "Producto" =>             {"important" => true,   "fixed" => false},
      "Cantidad solicitada" =>  {"important" => false,  "fixed" => false},
      "Cantidad aprobada" =>    {"important" => false,  "fixed" => false},
      "Unidad de medida" =>     {"important" => false,  "fixed" => false},
      "Especificación" =>       {"important" => false,  "fixed" => false},
      "Acción" =>               {"important" => true,   "fixed" => true}
    }

    def build_child_from_product product
      super do |d|
        d.product_code = product.code if d.class.column_names.include?("product_code")
        d.approved_quantity = 0
      end
    end

    def set_type
      unless new_record?
        if request_id.blank? && !request_detail_id.blank?
          self.type = ExpedientRequestDetail.unscoped.find(request_detail_id).type
        elsif !request_id.blank? && request_detail_id.blank?
          self.type = "#{ExpedientRequest.unscoped.find(request_id).type}Detail"
        end
      end
    end

    def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
      super do |o|
        o.product_code         = sr_detail.product_code if o.class.column_names.include?("product_code") && sr_detail.class.column_names.include?("product_code")
        o.product_supplier_code  = sr_detail.product_supplier_code if o.class.column_names.include?("product_supplier_code") && sr_detail.class.column_names.include?("product_supplier_code")
        o.approved_quantity    = sr_detail.quantity
        #o.supplier_price       = sr_detail.total
        o.description          = sr_detail.description if o.class.column_names.include?("description") && sr_detail.class.column_names.include?("description")
        yield self if block_given?
      end
    end

    def set_childs_current_user
      childs.each{ |child| child.current_user = self.current_user } if defined?(childs)
    end

    def approved_childs
      childs.where(state: ["Aprobada", "Aprobada con modificación"]) if defined?(childs)
    end

    def check_permissions
      class_name = self.class.name.gsub("Detail", "").constantize
      if current_user && current_user.cannot?(:approve, class_name)
        errors.add(:state, "No posee los permisos necesarios para modificar el estado.") if state_changed?
        errors.add(:approved_quantity, "No posee los permisos necesarios para modificar el estado.") if approved_quantity_changed?
      end
    end

    def approved_quantity
      read_attribute(:approved_quantity) || 0
    end

    def has_available_stock?
      Stock::Manager.new(producto: product).has_stock?
    end

    def has_enough_stock?
      Stock::Manager.new(product: product).has_enough_stock?(approved_quantity)
    end
end
