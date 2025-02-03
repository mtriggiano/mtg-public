class CompanyPresenter < BasePresenter
  presents :company
  delegate :name, to: :company
  delegate :contact_number, to: :company
  delegate :address, to: :company
  delegate :email, to: :company
  delegate :society_name, to: :company
  delegate :concept, to: :company
  delegate :cuit, to: :company
  delegate :currency, to: :company
  delegate :bills, to: :company

  def logo
    image_tag company.logo, width: '125px;', class: 'fit-shadow img-responsive'
  end

  def member_since
    company.created_at.strftime("%B %e, %Y")
  end

  def name
    handle_none(company.name)
  end

  def email
    handle_none(company.email)
  end

  def cuit
    handle_none(company.cuit)
  end

  def cbu
    handle_none(company.cbu)
  end

  def iva_cond
    handle_none(company.iva_cond)
  end

  def activity_init_date
    handle_none(company.activity_init_date)
  end

  def currency
    handle_none(Afip::MONEDAS.map{|m, c| m.to_s.titleize if c[:codigo] == company.currency}.compact.join())
  end

  def society_name
    handle_none(company.society_name)
  end

  def users_count
    company.users.count
  end

  def contact_number
    handle_none(company.contact_number)
  end

  def concept
    handle_none( Afip::CONCEPTOS.map{ |n, id| n if id == company.concept }.compact.join())
  end

  def address
    handle_none(company.address)
  end

  def province_id
    company.locality.province_id unless company.locality.nil?
  end

  def province
    if company.locality_id.nil?
      "Sin especificar"
    else
      company.locality.province.name
    end
  end

  def locality
    if company.locality_id.nil?
      "Sin especificar"
    else
      company.locality.name
    end
  end

  def country_id
    company.locality.province.country_id unless company.locality.nil? || company.locality.province.nil?
  end

  def last_month_incomes
    bills.where(flow: 'income', cbte_fch: [Date.today - 30.days..Date.today]).group_by_day(:cbte_fch).sum(:total)
  end

  def total_expenses
    #company.purchase_bills.approveds.sum(:total) + company.surgery_supplier_bills.approveds.sum(:total)
    "$ #{company.purchase_payment_orders.approveds.where(date: Date.today.at_beginning_of_month .. Date.today.at_end_of_month).sum(:total)}"
  end

  def total_income
    "$ #{company.receipts.where(date: Date.today.at_beginning_of_month .. Date.today.at_end_of_month).sum(:total)}"
  end

end
