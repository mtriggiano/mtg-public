class Finances::CashSolicitudeDatatable < ApplicationDatatable
  def get_raw_records
    @collection.includes(:cash_withdrawal, :expense_details, :cash_refund).references(:cash_withdrawal, :expense_details, :cash_refund).order(id: :desc)
  end
end
