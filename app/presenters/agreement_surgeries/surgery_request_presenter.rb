class AgreementSurgeries::SurgeryRequestPresenter < BasePresenter
  presents :surgery_request

  def id
    surgery_request.id
  end

  def number
	  link_to surgery_request.number, surgery_request
  end

  def document_number
	  surgery_request.document_number
  end

  def first_name
	  surgery_request.first_name
  end

  def last_name
	  surgery_request.last_name
  end

  def state
    title = surgery_request.rechazada? ? "#{surgery_request.rejected_by.try(:email)}: #{surgery_request.reason_for_rejection}" : nil
    "<span class='badge-#{state_css_class(surgery_request.aasm_state)} rounded p-2 small' title='#{title}'>#{surgery_request.aasm_state}</span>".html_safe
  end

  def state_for_audits(estado)
    clase = state_css_class(estado)
    "<span class='badge-#{clase} rounded p-2 small'>#{estado}</span>".html_safe
  end
  
  def state_as_dropdown
    title = surgery_request.rechazada? ? "#{surgery_request.rejected_by.try(:email)}: #{surgery_request.reason_for_rejection}" : nil

    pre_rechazar_path = pre_rechazar_agreement_surgeries_surgery_request_path(surgery_request)
    aprobar_path = aprobar_agreement_surgeries_surgery_request_path(surgery_request)
    coordinar_path = coordinar_agreement_surgeries_surgery_request_path(surgery_request)
    recuperar_path = recuperar_agreement_surgeries_surgery_request_path(surgery_request)
    a_espera_procesamiento_path = a_espera_procesamiento_agreement_surgeries_surgery_request_path(surgery_request)
    

    html = <<-HTML
      <div class="btn-group">
        <button type="button" class="btn btn-#{state_css_class(surgery_request.aasm_state)}" title="#{title}">#{surgery_request.aasm_state.upcase }</button>
        <button type="button" class="btn btn-#{state_css_class(surgery_request.aasm_state)} dropdown-toggle dropdown-toggle-split" style="z-index: 9999; " data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only"></span>
        </button>
        <div class="dropdown-menu" style="z-index: 9999; ">
          #{link_to("A espera de coordinacion", aprobar_path, method: :put, class: "dropdown-item") if ((surgery_request.may_a_espera_coordinacion?))}
          #{link_to("A rechazada", pre_rechazar_path, class: "dropdown-item") if (surgery_request.may_a_rechazada?) }
          #{link_to("A aprobada", coordinar_path, method: :put, class: "dropdown-item") if ((surgery_request.may_a_aprobada?))}
          #{link_to("A espera de aprobacion", recuperar_path, method: :put, class: "dropdown-item", style: "z-index: 9999;") if ((surgery_request.may_a_espera_aprobacion?))}
          #{link_to("A espera de procesamiento", a_espera_procesamiento_path, method: :put, class: "dropdown-item", style: "z-index: 9999;") if ((surgery_request.may_a_espera_procesamiento?))}
        </div>
      </div>
    HTML
    html.html_safe
  end

  def surgery_time
    surgery_request.surgery_time
  end

  def created_by
    link_to surgery_request.created_by.email, surgery_request.created_by if surgery_request.created_by
  end

  def created_at
    surgery_request.created_at
  end

  def action_links
  	content_tag :div do
      concat(link_to_show [surgery_request])
  		concat(link_to_edit [:edit, surgery_request])
  	end
  end

  private
  def state_css_class(estado)
    states = {
      "espera_aprobacion" => "info",
      "espera_coordinacion" => "warning",
      "espera_procesamiento" => "warning",
      "aprobada" => "success",
      "rechazada" => "danger",
    }
    states[estado]
  end
end
