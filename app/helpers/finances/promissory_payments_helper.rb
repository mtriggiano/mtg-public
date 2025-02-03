module Finances::PromissoryPaymentsHelper
  def color_por_dias_faltantes(dias)
    if dias <= 5
      "text-danger"
    end
  end

  def promissory_payment_color_state promissory_payment
    case promissory_payment.estado
    when "En cartera"
      "info"
    when "Depositado"
      "sucess"
    end
  end

  def emitted_check_color_state emitted_check
    case emitted_check.estado
    when "Anulado"
      "danger"
    when "Pagado"
      "success"
    else
      "info"
    end
  end
end
