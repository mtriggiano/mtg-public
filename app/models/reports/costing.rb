class Reports::Costing < ApplicationRecord
  self.table_name = :files
  self.inheritance_column = :_type_disabled
  self.abstract_class = true
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_many :purchase_orders,
    ->{where(state: "Aprobado")},
    class_name: 'Surgeries::PurchaseOrder',
    foreign_key: :file_id
  has_many :sale_orders,
    ->{where(state: "Aprobado")},
    class_name: 'Surgeries::SaleOrder',
    foreign_key: :file_id
  has_many :client_bills,
    ->{where(state: "Confirmado").where.not(cbte_tipo: ExpedientBill::CREDIT_NOTES)},
    class_name: "Surgeries::ClientBill",
    foreign_key: :file_id
  has_many :supplier_bills, ->{where.not(cbte_tipo: ExpedientBill::CREDIT_NOTES)}, through: :purchase_orders
  has_many :suppliers, through: :purchase_orders
  has_many :ordered_details, through: :purchase_orders, source: :details
  has_many :billed_details, through: :supplier_bills, source: :details
  has_many :client_billed_details, through: :client_bills, source: :details
  default_scope ->{where(type: "Surgeries::File")}
  store_accessor :custom_attributes, :doctor, :pacient


  include ReportsKit::Model
  reports_kit do
    aggregation :total_billed, [:sum, "CASE WHEN bills.cbte_tipo IN ('03', '08', '13', '203', '208', '213') THEN - bills.total ELSE bills.total END"]
    contextual_filter :for_file_bills, ->(relation, context_params) { relation.where("orders.type IN ('Surgeries::PurchaseOrder', 'Surgeries::SaleOrder') AND (bills.state = 'Aprobado' OR bills.state = 'Confirmado') AND (orders.file_id = #{context_params[:id]} OR bills.file_id = #{context_params[:id]})") }
    contextual_filter :for_file_orders, ->(relation, context_params){ relation.where("orders.file_id = #{context_params[:id]}")}
    dimension :bill_type, joins: ["
        LEFT OUTER JOIN orders ON orders.file_id = files.id
        INNER JOIN bills_orders ON bills_orders.order_id = orders.id
        INNER JOIN bills ON bills_orders.bill_id = bills.id"],
        group: "CASE WHEN bills.type = 'Surgeries::ClientBill' THEN 'F. Ventas' ELSE 'F. Compras' END"
    aggregation :total_ordered, [:sum, "orders.total"]
    dimension :order_type, joins: ["
      INNER JOIN orders ON orders.file_id = files.id AND orders.type IN ('Surgeries::SaleOrder', 'Surgeries::PurchaseOrder') AND orders.state = 'Aprobado'"],
      group: "CASE WHEN orders.type = 'Surgeries::SaleOrder' THEN 'O. Ventas' ELSE 'O. Compras' END"
  end

  def sum_for_type
    ActiveRecord::Base.connection.exec_query("
      SELECT SUM(tb1.total) AS bills_total, tb1.type AS bills_type FROM bills AS tb1 INNER JOIN bills_orders on tb1.id = bills_orders.bill_id INNER JOIN orders ON orders.id = bills_orders.order_id WHERE orders.file_id = #{id} AND tb1.state = 'Aprobado'  AND tb1.type = 'ExternalBill' GROUP BY bills_type
      UNION
      SELECT SUM(tb2.total) AS bills_total, tb2.type AS bills_type FROM bills AS tb2 INNER JOIN files on tb2.file_id = #{id} WHERE tb2.type = 'Surgeries::ClientBill' AND tb2.state = 'Confirmado' GROUP BY bills_type")
      .rows
  end

  def self.search(args={})
    query     = []
    from      = args[:from]
    to        = args[:to]
    doctor    = args[:doctor]
    supplier  = args[:supplier]
    patient   = args[:patient]
    client    = args[:client]

    query << "joins(:suppliers).where('entities.name ILIKE LOWER(?)', '%#{supplier.downcase}%')" if supplier
    query << "joins(:client).where('entities.name ILIKE LOWER(?)', '%#{client.downcase}%')" if client
    query << "where(surgery_end_date: [from..to])" if from && to
    query << "where(\"custom_attributes -> 'doctor' ILIKE LOWER(?)\", \"%#{doctor.downcase}%\")" if doctor
    query << "where(\"custom_attributes -> 'pacient' ILIKE LOWER(?)\", \"%#{patient.downcase}%\")" if patient
    eval query.join(".")
  end

  def all_products
    #TODO: FILTER FROM CREDIT NOTES
    (billed_details + client_billed_details)
    .group_by(&:product_name)
    .map{|name, details| {
      name: name,
      earned: details.select{
        |detail| detail.type == 'Surgeries::ClientBillDetail' && detail.subtype == 'Surgeries::ClientBillInventary'
      }.pluck(:total).sum,
      expended: details.select{
        |detail| detail.type == 'ExternalBillDetail' && detail.subtype == 'BillInventary'
      }.pluck(:total).sum
    }}
  end

  def all_services
    #TODO: FILTER FROM CREDIT NOTES
    (billed_details.where(subtype: 'BillService') + client_billed_details.where(subtype: 'Surgeries::ClientBillService'))
    .group_by(&:product_name)
    .map{|name, details| {
      name: name,
      earned: details.select{
        |detail| detail.type == 'Surgeries::ClientBillDetail'
      }.pluck(:total).sum,
      expended: details.select{
        |detail| detail.type == 'ExternalBillDetail'
      }.pluck(:total).sum
    }}
  end

  def products
    billed_details.where(subtype: "BillInventary")
  end

  def services
    billed_details.where(subtype: "BillService")
  end

  def product_costing
    products.sum(:total).to_f.round(2)
  end

  def service_costing
    services.sum(:total).to_f.round(2)
  end

  def product_gain
    client_billed_details
      .where(subtype: "Surgeries::ClientBillInventary")
      .sum(:total).to_f.round(2)
  end

  def service_gain
    client_billed_details
      .where(subtype: "Surgeries::ClientBillService")
      .sum(:total).to_f.round(2)
  end

  def shipment_costing
    purchase_orders.sum(:shipping_price).round(2)
  end

  def cash_account_expenditures_costing
    ExpenseDetail.where(order_id: purchase_orders.map(&:id) + sale_orders.map(&:id)).sum(:total)
  end

  def margin
    sale_orders.sum(:total) - purchase_orders.sum(:total)
  end
end
