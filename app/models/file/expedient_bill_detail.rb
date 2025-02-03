class ExpedientBillDetail < ApplicationRecord
    self.table_name = :bill_details
    self.ignored_columns = %w(product_supplier_code)
	  STATES = ExpedientBill::STATES
  	scope :approveds, ->{where(state: "Aprobado")}
    include ProductDetails
    before_validation :update_data
    belongs_to :seller, class_name: "User", foreign_key: :seller_id, optional: true
    belongs_to :expedient_bill, foreign_key: :bill_id, inverse_of: :details, optional: true
    belongs_to :seller, class_name: "User", optional:  true
    include ReportsKit::Model
    reports_kit do
      aggregation :total_selled, [:sum_and_filter, ""]
      aggregation :total_selled_usd, [:sum, "bills.total_usd"]
      dimension :date, joins: :expedient_bill, group: 'EXTRACT( MONTH FROM bills.date)'
      filter :date, :datetime, joins: :expedient_bill, column: 'bills.date'
      #filter :is_billed, :boolean, joins: :expedient_bill, conditions: ->(relation) { relation.where("bills.state = 'Confirmado' AND bills.canceled = 'false'")}
      dimension :seller, joins: :seller, group: "(users.last_name || ', ' || users.first_name)"
      dimension :total_usd, joins: :expedient_bill, column: "SUM(bills.total_usd)"
    end

  	def check_permissions
      if current_user.cannot?(:approve, SaleBudget)
        errors.add(:state, "No posee los permisos necesarios para modificar el estado.") if state_changed?
      end
    end

    def self.sub_search from: Date.today.at_beginning_of_month, to: Date.today, sellers:
      return where("1=0") if sellers.blank? || sellers.size == 0

      joins(:expedient_bill)
      .where(seller_id: sellers)
      .where(bills:{date: [from.to_date..to.to_date]})
    end

    def self.search_by_date(from: Date.today - 1.months, to: Date.today)
      joins(:expedient_bill)
      .where(bills:{date: [from.to_date..to.to_date]})
    end

    def self.search_by_sellers sellers:
      if sellers.blank? || sellers.size == 0
        all
      else
        joins(:expedient_bill)
        .where(seller_id: sellers)
      end
    end

    def self.sub_client_search from: Date.today.at_beginning_of_year, to: Date.today.at_end_of_year, clients:
      from = from&.to_date
      to = to&.to_date
      if clients.nil? || clients.size == 0
        where(bills:{date: [from..to]})
      else
        where(bills: {type: ["Sales::Bill", "Surgeries::ClientBill"], entity_id: clients, date: [from..to]})
      end
    end

    def self.sum_and_filter attr
      joins(:expedient_bill).where(bills: {state: ["Confirmado", "Anulado"]}).sum("CASE WHEN bills.cbte_tipo::int IN (#{ExpedientBill::CREDIT_NOTES.join(", ")}) THEN -bill_details.total ELSE bill_details.total END")
    end

    def self.select_real_total
      joins(:expedient_bill).select("bill_details.*, CASE WHEN bills.cbte_tipo IN ('03', '08', '13', '203', '208', '213') THEN -bill_details.total ELSE bill_details.total END as real_total")
    end

    def self.custom_data_method properties
      from = properties[:ui_filters][:date].split(" - ").first
      to = properties[:ui_filters][:date].split(" - ").last
      self.joins(:expedient_bill, :seller)
      .where(bills: {state: ["Confirmado", "Anulado"], date: [from..to] })
      .group("(users.last_name || ', ' || users.first_name)")
      .sum("CASE WHEN bills.cbte_tipo::int IN (#{ExpedientBill::CREDIT_NOTES.join(", ")}) THEN -bill_details.total ELSE bill_details.total END")
      .map{|k,v| [[k, "Total vendido ($)"], v]}
    end

    def update_data
      set_custom_product_name
      set_iva_amount
      set_neto
      set_bonus_amount
    end

    def build_child_from_product product
    end

    def build_childs(so_detail)
      nil
    end

    def product_measurement
      super || "Unidad"
    end

    def set_neto
      self.neto = (price.to_f * quantity.to_f) * (1 - discount.to_f/100).round(2)
    end

    def set_iva_amount
      self.iva_amount = (((quantity.to_f* price.to_f) * iva.to_f) * (1 - discount/100)).round(2)
    end

    def set_bonus_amount
      self.bonus_amount = (price * quantity) * (discount / 100)
    end

    def iva
      Afip::ALIC_IVA.to_h[iva_aliquot].to_f
    end

    def bonus_percentage
      bonus_amount * 100 / total
    end

    def set_custom_product_name
      self.product_name = self.inventary.name if product_id
    end

    def has_model_childs?
      false
    end

    def real_total
      read_attribute(:real_total)
    end


end
