class ExpedientBudget < ApplicationRecord
  self.table_name = :budgets
	include StateManager
  include BudgetValidator
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Numerable
  include Reopener
  include PdfCurrency

  BUDGET_STATES = ["Pendiente", "No adjudicado", "Adjudicado"]

  belongs_to :company
  belongs_to :entity
  belongs_to :user, optional: true
  belongs_to :file, class_name: "Expedient"
  belongs_to :entity_contact, optional: true
  belongs_to :seller, optional: true, class_name: "User"
  attribute  :current_user, User

  has_many    :responsables, through: :file

  before_validation :set_subtotal, :set_bonification

  include ReportsKit::Model
  reports_kit do
    aggregation :total_budgeted, [:sum_and_filter, ""]
    dimension :init_date, group: 'EXTRACT( MONTH FROM budgets.init_date)'
    filter :init_date, :datetime, column: 'budgets.init_date'
    dimension :seller, joins: :seller, group: "(users.last_name || ', ' || users.first_name)"
    dimension :entity, joins: :entity, group: 'entities.name'
  end

  def self.sum_and_filter attr
    where(state: "Aprobado", type: ["Sales::Budget", "Surgeries::Budget", "Tenders::Budget"]).sum(:total)
  end

  def discount_in_percentage
    percentage = discount * 100 / total
    percentage.nan? ? "0%" : "#{percentage}%"
  end

  def start_time
    file&.delivery_date
  end

  def init_date
    read_attribute(:init_date) || file.try(:init_date) || Date.today
  end

  def final_date
    read_attribute(:final_date) || file.try(:finish_date) || (init_date || Date.today) + 1.days
  end

  def set_subtotal
    self.subtotal = details.select{|d| d.base_offer }.inject(0){|sum, det| sum + ((det.quantity * det.price) * (1 - (det.discount/100)))}
  end

  def set_bonification
    self.discount = details.select{|d| d.base_offer }.sum{|d| (d.price * d.quantity * d.discount / 100).round(2)}
  end

  def pdf_name
    "presupuesto_#{number}"
  end

end
