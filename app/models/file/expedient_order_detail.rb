class ExpedientOrderDetail < ApplicationRecord
  self.table_name = :order_details
  STATES = ExpedientOrder::STATES
  self.ignored_columns = %w(product_supplier_code)
  include ProductDetails
  #include ProductInheritance
  default_scope ->{where custom_detail: false, active: true}
  scope :approveds, ->{where(state: "Aprobado")}
  validates_presence_of :price, message:"Debe especificar"
  belongs_to :order, class_name: "ExpedientOrder", foreign_key: :order_id, optional: true
  belongs_to :seller, class_name: "User", foreign_key: :user_id, optional: true
  belongs_to :inventary, foreign_key: :product_id, optional: true
  belongs_to :expedient_order, foreign_key: :order_id, optional: true

  store_accessor :custom_attributes,
                  :arrivaled,
                  :arrival_detail_id,
                  :arrival_custom_detail_id,
                  :arrival_state,
                  :arrival_quantity,
                  :billed,
                  :bill_custom_detail_id,
                  :bill_detail_id,
                  :bill_state,
                  :bill_quantity

  def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    super do |o|
      #o.price                 = sr_detail.try(:price) || (total.to_f / (quantity.to_f * (1 + iva.to_f))).round(1)
      o.discount              = sr_detail.discount if sr_detail.class.column_names.include?("discount")
      #o.total                 += (sr_detail.try(:total) || sr_detail.try(:supplier_price)).to_f.round(1)
      o.description           = sr_detail.description if sr_detail.class.column_names.include?("description")
      yield o if block_given?
    end
  end


  def build_child_from_product product
    super do |p|
      p.product_code = product.code
    end
  end

  def iva_amount
    (price.to_f * quantity.to_f * (1 - (discount.to_f/100))) * iva.to_f
  end
end
