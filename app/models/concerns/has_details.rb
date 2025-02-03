# frozen_string_literal: true

module HasDetails
  extend ActiveSupport::Concern

  included do
    attr_accessor       :approved_state
    attr_accessor       :inherit_details_from
    attr_accessor       :filter_details_from
    attr_accessor       :rest_details_from
    attr_accessor       :secondary_assign_details_from
    attr_accessor       :has_childs

    after_initialize :build_init_detail, if: :new_record?
    before_validation :at_least_one_detail

    before_save :set_childs_parent
    before_validation :update_details

    def self.inherited(subclass)
      super
      subclass.class_eval do
        has_many :details,-> { order(created_at: :asc) }, class_name: "#{name}Detail", dependent: :destroy, foreign_key: "#{table_name.singularize}_id", inverse_of: name.demodulize.snakecase.to_sym, validate: true
        has_many :childs,-> { order(created_at: :asc) }, through: :details, source: :childs, validate: true
        #validates_associated :details, message: "Uno o más de los productos no son válidos."
        ####### REVISAR QUE NO GUARDA DETALLES SI NO TIENE PRODUCT ID EN LOS CASOS DE CIRUGÍA DONDE NO SE SELECCIONA UN PRODUCTO SINO QUE SE LLENA EL DETALLE
        ####### NOSE SI AFECTARÁ EN ALGUN OTRO LADO QUE YO SAQUE EL c["product_id"].blank?
        accepts_nested_attributes_for :childs, reject_if: :reject_childs_product?, allow_destroy: true
        accepts_nested_attributes_for :details, reject_if: :reject_childs_product?, allow_destroy: true
      end
    end
  end

  def need_merge?
    true
  end

  def update_details
    details.each do |detail|
      detail.updated_at = Time.now
      if detail.class.column_names.include?("#{detail.class.table_name.singularize.demodulize.underscore}_id")
        detail.childs.each do |child|
          child.updated_at = Time.now
        end
      end
    end
  end

  def reject_childs_product?(att)
    att["product_name"].blank? && att["product_id"].blank?
  end

  def build_init_detail
    details.build(number: 1) if details.empty?
  end

  def set_childs_parent
    details.each do |detail|
      detail.childs.each { |child| eval("child.#{child.class.parent_id} ||= detail.id") } unless detail.try(:childs).nil?
    end
  end

  def at_least_one_detail
    details.build if details.reject(&:marked_for_destruction?).empty?
  end

  def add_detail(box, detail, supplier_id = nil, page)
    detail.build_childs_from_box(box, supplier_id, page) unless box.nil?
  end

  def hash_accessor(attr)
    ->(hash) { hash.last[attr] }
  end

  def assign_details(documents, number)
    details.each(&:mark_for_destruction)
    documents = documents.permit(:number, :file_id, documents: [:document, :id, :method, :skip_filter_inheritance]).to_h[:documents].group_by { |k,v| v["method"] }
    self.file_id ||= documents[:file_id]
    if documents["assign"]
      for_assign(documents["assign"], number)
    else
      for_secondary_assign(documents["secondary_assign"], number)
    end
    for_filter(documents["filter"])
    for_rest(documents["rest"])
  end

  def for_assign(documents, number)
    if documents
      ids = documents.map(&hash_accessor('id'))
      parent_class = self.class.name.deconstantize.blank? ? nil : "#{self.class.name.deconstantize.singularize.snakecase}_"
      from = "#{parent_class}#{self.class.inherit_details_from.pluralize}"
      skip_filter_inheritance = documents.map(&hash_accessor('skip_filter_inheritance')).first
      documents = eval("company.#{from}").where(id: ids)
      assign(documents, number, skip_filter_inheritance)
    end
  end

  def for_secondary_assign(documents, number)
    if documents
      ids = documents.map(&hash_accessor('id'))
      parent_class = self.class.name.deconstantize.blank? ? nil : "#{self.class.name.deconstantize.singularize.snakecase}_"
      from = "#{parent_class}#{self.class.secondary_assign_details_from.pluralize}"
      documents = eval("company.#{from}").where(id: ids)
      assign(documents, number)
    end
  end

  def for_filter(documents)
    if documents
      ids = documents.map(&hash_accessor('id'))
      parent_class = self.class.name.deconstantize.blank? ? nil : "#{self.class.name.deconstantize.singularize.snakecase}_"
      from = "#{parent_class}#{self.class.filter_details_from.pluralize}"
      documents = eval("company.#{from}").where(id: ids)
      filter(documents)
    end
  end

  def for_rest(documents)
    if documents
      ids = documents.map(&hash_accessor('id'))
      from = "#{self.class.name.deconstantize.singularize.downcase}_#{self.class.rest_details_from.pluralize}"
      documents = eval("company.#{from}").where(id: ids)
      rest(documents)
    end
  end

  def recharge(_documents)
    if attributes['entity_id']
      entity.try(:recharge).to_f
    end
  end

  def assign_entity(documents)
    if self.respond_to?(:entity) && documents.last.respond_to?(:entity)
      entity_id = documents.last.entity_id
      self.entity_id = entity_id unless entity_id.nil?
    end
  end

  def assign(documents, supplier_id = nil, skip_filter_inheritance)
    assign_entity(documents)
    details.each{|d| d.quantity = 0}
    @skip_filter_inheritance = skip_filter_inheritance
    documents.includes(details: :product).each do |document|
      document.details.each_with_index do |document_detail, index|
        current_details = details.select{|d| d.product_name == document_detail.product_name && d.try(:product_code) == document_detail.try(:product_code)}
        if current_details.any?
          current_details.each{|cd| cd.marked_for_destruction = false}
          current_details.each{|cd| cd.skip_filter_inheritance = skip_filter_inheritance}
          current_details.first.assign_from_another(document_detail, recharge(documents), false, supplier_id)
        else
          d = details.build
          d.skip_filter_inheritance = skip_filter_inheritance
          d.assign_from_another(document_detail, recharge(documents), false, supplier_id)
        end
      end
    end
  end

  def rest(documents)
    old_details = details.target.reject(&:marked_for_destruction?)
    details.each(&:mark_for_destruction)

    documents.includes(details: [:product, childs: :product]).each do |document|
      document.details.each do |document_detail|
        old_details.select{|pod| pod.product_id == document_detail.product_id}.each do |od|
          od.quantity -= document_detail.quantity
          unless od.product_name.blank?
            det = details.build(od.attributes)
            if od.try(:childs)
              document_detail.childs.each do |document_child|
                od.childs.select{ |poc| poc.product_id == document_child.product_id}.each do |oc|
                  oc.quantity -= document_child.quantity
                  det.childs.build(oc.attributes) unless oc.product_name.blank?
                end
              end
            end
          end
        end
      end
    end
  end

  def filter(documents)
    old_details = details.target.reject(&:marked_for_destruction?)
    #details.each(&:mark_for_destruction)
    filter_products = []
    documents.includes(details: [:product, childs: :product]).each do |document|
      document.details.each do |document_detail|
        filter_products << document_detail.product_name
        current_details = details.select{|d| d.product_name == document_detail.product_name && d.product_code == document_detail.product_code && !document_detail.marked_for_destruction?}
        current_details.each{|cd| cd.marked_for_destruction = cd.marked_for_destruction?}
        if current_details.any?
          current_details.first.quantity = documents.inject(0){|suma, doc| suma + doc.details.select{|d| d.product_name == document_detail.product_name && d.product_code == document_detail.product_code}.map(&:quantity).sum}
        else
          details.build.filter_from_another(document_detail)
        end
      end
    end
    details.each{|d| d.mark_for_destruction unless (filter_products.include? d.product_name)}
  end

  class_methods do

    def approved_state(val = nil)
      if val.nil?
        @approved_state
      else
        @approved_state = val.to_s.capitalize
      end
    end

    def inherit_details_from(val = nil)
      if val.nil?
        @inherit_details_from
      else
        @inherit_details_from = val.to_s
      end
    end

    def filter_details_from(val = nil)
      if val.nil?
        @filter_details_from
      else
        @filter_details_from = val.to_s
      end
    end

    def rest_details_from(val = nil)
      if val.nil?
        @rest_details_from
      else
        @rest_details_from = val.to_s
      end
    end

    def secondary_assign_details_from(val = nil)
      if val.nil?
        @secondary_assign_details_from
      else
        @secondary_assign_details_from = val.to_s
      end
    end

    def approved_details
      if approved_state
        details.where(state: approved_state)
      else
        details
      end
    end

    def has_childs(value = true)
      @has_childs = value
      return value
    end
  end
end
