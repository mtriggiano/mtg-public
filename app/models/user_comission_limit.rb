class UserComissionLimit < ApplicationRecord
  belongs_to :user

  PERIODS = ["Mensual", "Trimestral", "Semestral"]


  def period_date
    date = Date.today
    case period
    when "Mensual"
      init_date = date.at_beginning_of_month
      final_date = date.at_end_of_month
    when "Trimestral"
      init_date = date.at_beginning_of_quarter
      final_date = date.at_end_of_quarter
    when "Semestral"
      if date < "01/07/#{date.year}".to_date
        init_date = "01/01/#{date.year}".to_date
        final_date = "30/06/#{date.year}".to_date
      else
        init_date = "01/07/#{date.year}".to_date
        final_date = "31/12/#{date.year}".to_date
      end
    else
      init_date = date.at_beginning_of_month
      final_date = date.at_end_of_month
    end
    return init_date, final_date
  end

  def period_label
    init_date, final_date = period_date
    return "Objetivo #{period}: Desde #{init_date} hasta #{final_date}. Monto: $#{amount}"
  end

end
