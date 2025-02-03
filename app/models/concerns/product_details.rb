module ProductDetails
  extend ActiveSupport::Concern

  included do
    def self.inherited(subclass)
      super
      subclass.class_eval do
        attr_accessor       :abstract_stock
        attr_accessor       :table_alias
        attr_accessor       :skip_filter_inheritance
        belongs_to name.demodulize.snakecase.gsub('_detail', '').to_sym, #prescription
          inverse_of: :details,
          class_name: name.gsub('Detail', ''),                           #Surgeries::Prescription
          foreign_key: table_name.gsub('_details', '_id'),               #request_id
          optional: true
        belongs_to :detail,
          foreign_key: "#{table_name.singularize}_id",
          class_name: name,
          optional: true,
          inverse_of: :childs
        #after_initialize :set_number

        belongs_to :product, optional: true
        belongs_to :inventary, foreign_key: :product_id, optional: true
        has_many   :childs, ->{order(:number)},foreign_key: "#{table_name.singularize}_id", class_name: name, inverse_of: :detail
        accepts_nested_attributes_for :childs, reject_if: Proc.new{|c| c["product_name"].blank? && c["product_id"].blank?}, allow_destroy: true
        #validates_associated :childs, message: "Uno o mas de los productos de una caja no son válidos.", if: :has_childs?
        before_validation :set_product_name
        before_validation :set_product_code,     if: proc { |o| o.product_id_changed? && o.class.contains_attr('product_code') }
        before_validation :set_product_price, if: proc { |o| o.product_id_changed? && o.class.contains_attr('price') }
        before_validation :set_product_discount, if: proc { |o| o.product_id_changed? && o.class.contains_attr('discount') }
        before_validation :set_product_total,  if: proc { |o| o.product_id_changed? && o.class.contains_attr('total') }

        validates_presence_of       :product_id, message: 'Debe tener un producto o servicio asociado al detalle.', if: :needs_product?
        validates_presence_of       :product_name, message: 'Debe tener un producto o servicio asociado al detalle.', if: :product_id_changed?
        validates_presence_of       :product_code, message: 'Debe tener un producto o servicio asociado al detalle.', if: proc { |o| o.class.contains_attr('product_code') && o.needs_product? }
        #validates_presence_of      :product_supplier_code, message: 'Debe tener un producto o servicio asociado al detalle.', if: proc { |o| o.class.contains_attr('product_supplier_code') }
        validates_presence_of       :quantity, message: 'Debe especificar la cantidad.',                     if: proc { |o| o.class.contains_attr('quantity') }
        validates_numericality_of   :quantity, greater_than: 0, message: 'La cantidad debe ser mayor a 0.',  if: proc { |o| o.class.contains_attr('quantity') && !skip_quantity_validation?}
        validates_presence_of       :approved_quantity, message: 'Debe especificar la cantidad aprobada.', if: proc { |o| o.class.contains_attr('approved_quantity') }
        validates_numericality_of   :approved_quantity, greater_or_equal_than: 0, message: 'La cantidad debe ser un número.',  if: proc { |o| o.class.contains_attr('approved_quantity') }
        #validates_presence_of      :state, message: 'Debe especificar el estado del detalle.', if: proc { |o| o.class.contains_attr('state') }
        #validates_inclusion_of     :state, in: self::STATES, message: 'Debe especificar el estado del detalle.',  if: proc { |o| o.class.contains_attr('state') }
        validates_length_of         :description, maximum: 500, message: 'Demasiados caracteres, intente con una descripción mas corta', allow_blank: true, if: proc { |o| o.class.contains_attr('descripción') }
        validates_length_of         :product_supplier_code, maximum: 20, message: 'Código de proveedor demasiado largo. Máximo 20 caracteres', if: proc { |o| o.class.contains_attr('product_supplier_code') }
        validates_numericality_of   :price, greater_or_equal_than: 0, message: 'El precio debe ser mayor a 0.', if: proc { |o| o.class.contains_attr('price') && o.is_a_detail? }
        validates_numericality_of   :discount, less_than_or_equal_to: 100, message: 'El descuento es inválido, ingrese un número.', if: proc { |o| o.class.contains_attr('discount') && o.is_a_detail? }
        validates_numericality_of   :total, greater_or_equal_than: 0, message: 'El subtotal debe ser mayor a 0.',  if: proc { |o| o.class.contains_attr('total') && o.is_a_detail? }
        validates_presence_of       :product_measurement, message: 'Debe especificar la unidad de medida.', if: proc { |o| o.class.contains_attr('product_measurement') }
        validates_length_of         :product_measurement, maximum: 50, message: 'Unidad de medida demasiado larga', if: proc { |o| o.class.contains_attr('product_measurement') }
        validates_length_of         :description, maximum: 5000, message: 'Descripción muy larga. Máximo 5000 caracteres', allow_blank: true, if: proc { |o| o.class.contains_attr('description') }
        validates_uniqueness_of     :product_name, message: "Concepto repetido", scope: [:active, name.demodulize.snakecase.gsub('_detail', '').to_sym], if: proc{|o| o.is_a_detail? && o.class.contains_attr(o.class.name.demodulize.snakecase.gsub('_detail', ''))}, case_sensitive: false
        validates_uniqueness_of     :product_name, message: "Concepto repetido", scope: [:active,name.demodulize.snakecase.to_sym], if: proc{|o| o.is_a_child? && o.class.contains_attr(o.class.name.demodulize.snakecase)}, case_sensitive: false
        validate :product_belongs_to_company


        after_validation :set_product_id_error
        def parent
          detail || eval(self.class.name.demodulize.snakecase.gsub('_detail', '').to_s)
        end

        def skip_filter_inheritance=(value)
          @skip_filter_inheritance = value == "true"
        end

        def skip_filter_inheritance
          @skip_filter_inheritance
        end

        def set_number
          if !parent.nil? && parent.respond_to?(:details)
            self.number ||=  parent.details.reject(&:marked_for_destruction?).size + 1
          elsif !parent.nil? && parent.respond_to?(:childs)
            self.number ||=  parent.childs.reject(&:marked_for_destruction?).size + 1
          end
        end

        def is_a_child?
          parenthood == 'child'
        end
      end
    end

    def iva
      Afip::ALIC_IVA.map { |a| a.last if a.first == iva_aliquot }.compact.first
    end

    def set_product_id_error
      if errors[:product_name].any?
        errors[:product_name].each do |e|
          errors.add(:product_id, e)
        end
      end
    end

    def branch
      return nil unless self.class.column_names.include?("branch")
      super || (self.inventary.nil? ? nil : self.inventary.branch)
    end

    def source
      return nil unless self.class.column_names.include?("source")
      super || (self.inventary.nil? ? nil : self.inventary.source)
    end

    def product_measurement
      return "Unidad" unless self.class.column_names.include?("product_measurement")
      super || "Unidad"
    end

    def product_measurement=(value="Unidad")
      super if self.class.column_names.include?('product_measurement')
    end
  end

  def needs_product?
    if self.class.abstract_stock
      return false
    else
      if is_a_product?
        return true
      else
        return false
      end
    end
  end

  def is_a_service?
    self.class.contains_attr('detail_type') && self.detail_type == "Servicio"
  end

  def is_a_product?
    !is_a_service?
  end

  def set_product_name
    self.product_name = Inventary.find(product_id).name if product_id
  end

  def parenthood
    case parent.class.name
    when self.class.name
      'child'
    when self.class.name.gsub('Detail', '')
      'detail'
    end
  end

  def is_a_detail?
    parenthood == 'detail'
  end

  def has_childs?
    if self.class.column_names.include?("#{self.class.table_name.singularize}_id")
      eval("#{self.class.table_name.singularize}_id").blank? && childs.size > 0
    else
      false
    end
  end

  def has_model_childs?
    true
  end

  def is_not_a_child?
    !is_a_child?
  end

  def set_product_code
    self.product_code = Inventary.find(product_id).code if product_id
  end

  def set_product_price
    self.price = 0 if price.blank?
  end

  def set_product_discount
    self.discount = 0 if discount.blank?
  end

  def set_product_total
    self.total = 0 if total.blank?
  end

  def product_belongs_to_company
    parent = eval(self.class.name.demodulize.gsub('Detail', '').snakecase)
    unless product_id.blank? || parent.blank? || inventary.company&.id == parent.company_id
      errors.add(:product_id, 'El producto es incorrecto')
    end
  end

  def build_childs_from_box(box, supplier_id = nil, page)
    if box.is_a_box?
      box.products.select('box_products.quantity as quantity, products.*').paginate(per_page: 50, page: page).each { |child_product| build_child_from_product(child_product) }
    end
  end

  def childs_size
    dig(:inventary, :is_a_box?) ? dig(:inventary, :products, :size) : 0
  end

  def build_childs(so_detail)
    if so_detail.has_model_childs?
      so_detail.childs.each do |child|
        if childs.klass.column_names.include?('product_code')
          current_child = childs.select{|c| c.product_code == child.product_code && c.product_name == child.product_name}
        else
          current_child = childs.select{|c| c.product_name == child.product_name}
        end
        if current_child.any?
          current_child.first.assign_from_another(child, nil, true)
          c = current_child.first
        else
          c = childs.build
          c.assign_from_another(child, nil, true)
        end
        unless c.marked_for_destruction?
          self.marked_for_destruction = false
        end
      end
    end
  end

  def marked_for_destruction=(val)
    @marked_for_destruction = val
  end

  def assign_from_another(so_detail, _recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
    Inventary.unscoped do
      self.errors.add(:product_id, "El producto fue eliminado. ID #{so_detail.product_id}") if so_detail.inventary && !so_detail.inventary.active
    end
    if !self.class.contains_attr('detail_type') && so_detail.product_id.nil?
      self.mark_for_destruction
    else
      self.reload if self.marked_for_destruction?
    end

    if self.include_column?("product_code") && needs_product?
      self.product_code      = so_detail.try(:product_code)  || so_detail.inventary.try(:code)
    end

    if so_detail.include_column?("iva_amount") && self.include_column?("iva_amount")
      self.iva_amount += so_detail.iva_amount
    end

    if so_detail.include_column?("base_offer") && self.include_column?("base_offer")
      self.base_offer = so_detail.base_offer
    end

    if so_detail.include_column?("iva_amount") && self.include_column?("iva_amount")
      self.iva_amount += so_detail.iva_amount
    end

    if so_detail.include_column?("base_offer") && ["Surgeries::BudgetDetail", "Sales::BudgetDetail"].include?(so_detail.class.name)
      self.mark_for_destruction unless (so_detail.base_offer || child)
    end

    if so_detail.include_column?("iva_aliquot") && self.include_column?("iva_aliquot")
      self.iva_aliquot = so_detail.iva_aliquot
    end

    if so_detail.include_column?("branch") && self.include_column?("branch")
      self.branch = so_detail.branch
    end

    if so_detail.include_column?("source") && self.include_column?("source")
      self.source = so_detail.source
    end

    if so_detail.include_column?("detail_type") && self.include_column?("detail_type")
      self.detail_type = so_detail.detail_type
    end

    if so_detail.include_column?("price") && self.include_column?("price")
      self.price = so_detail.price
    end

    self.product_id          = so_detail.product_id
    self.product_name        = so_detail.product_name
    self.product_measurement = "Unidad" if self.include_column?("product_measurement")

    yield self if block_given?
    # After assign values, we must assign childs
    build_childs(so_detail) unless child
  end

  def filter_from_another(so_detail)
    self.product_id  = so_detail.product_id if so_detail.class.contains_attr("product_id")
    self.product_name = so_detail.product_name
    if so_detail.respond_to?("#{self.class.name.demodulize.gsub("Detail", "").parameterize}_quantity")
      self.quantity = so_detail.quantity - so_detail.send("#{self.class.name.demodulize.gsub("Detail", "").parameterize}_quantity").to_i
    else
      self.quantity = so_detail.quantity
    end
    self.mark_for_destruction if self.quantity <= 0
  end

  def include_column?(column)
    self.class.column_names.include?(column)
  end

  def build_child_from_product(product)
    childs.build do |c|
      c.product_name         = product.name
      c.quantity             = product.quantity
      c.product_id           = product.id
      c.product_measurement  = product.medida if c.class.column_names.include?('product_measurement')
      c.product_code         = product.code if c.class.column_names.include?('product_code')
      c.source               = product.source if c.class.column_names.include?('source')
      c.branch               = product.branch if c.class.column_names.include?('branch')
      yield c if block_given?
    end
  end


  class_methods do
    def table_alias=(value)
        @table_alias = value.to_s
    end

    def table_alias
        @table_alias || table_name
    end
    def contains_attr(attribute)
      column_names.include?(attribute)
    end

    def available_states
      STATES if const_defined?('STATES')
    end

    def parent_id
      parent_key = "#{table_name.singularize}_id"

      if column_names.include?(parent_key)
        return parent_key
      else
        return false
      end
    end

    def abstract_stock=(val)
      @abstract_stock = val
    end

    def abstract_stock
      @abstract_stock
    end
  end

  protected

  def skip_quantity_validation?
    false
  end
end
