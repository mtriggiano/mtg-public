class AgreementSurgeries::FilePresenter < Sales::FilePresenter
  presents :file

  def id
    file.id
  end

  def created_at
  	file.created_at
  end

  def user
  	file.user
  end

  def implant
    link_to file.implant_original_filename, file.implant_certificate unless file.implant_certificate == "/images/attachment.png"
  end

  def surgery_request
    link_to file.surgery_request.number, file.surgery_request if file.surgery_request
  end

  def dni
    link_to file.dni, file.dni unless file.dni == "/images/attachment.png"   
  end

  def anses_negative
    link_to file.anses_negative, file.anses_negative unless file.anses_negative == "/images/attachment.png"   
  end

  def anses_no_negative
    link_to file.anses_no_negative, file.anses_no_negative unless file.anses_no_negative == "/images/attachment.png"    
  end

  def surgical_sheet
    link_to file.surgical_sheet, file.surgical_sheet unless file.surgical_sheet == "/images/attachment.png"
  end

  def codem
    file.codem    
  end

  def clinical_record_cover
    file.clinical_record_cover    
  end

  def implant_certificate
    link_to file.implant_certificate, file.implant_certificate unless file.implant_certificate == "/images/attachment.png"
  end

  def document_type
    Afip::DOCUMENTOS.key(file.document_type)
  end

  def internal_stock
    file.internal_stock = "true" ? "Si" : "No"
  end

  def number
    file.number
  end

  def request_date
    handle_date_long(Date.parse(file.request_date)) if file.request_date
  end

  def surgery_date
    handle_date_long(Date.parse(file.surgery_date)) if file.surgery_date
  end

  def birthday
    handle_date_long(Date.parse(file.birthday)) if file.birthday
  end

  def action_links
    content_tag :div do
      concat(link_to_show [file])
      concat(link_to_edit [:edit, file])
    end
  end
end