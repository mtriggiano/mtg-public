class Surgeries::ExpedientMailer < ApplicationMailer

  # envuiamos notificacion al equipo de ventas
  def send_sin_documentacion_to_ventas
    puts "ejecutando envio de emails para vendedores"
    existing_job = Delayed::Job.where("handler LIKE ?", "%send_sin_documentacion_to_ventas%").first
    if !existing_job.present? 
      hora = (DateTime.now + 1.day).midnight + 21.hours
      Surgeries::ExpedientMailer.delay(run_at: hora).send_sin_documentacion_to_ventas
    end
    # aca debe tomar la fecha de cirujia de Surgeries::SaleOrder
    # el campo se llama expected_delivery_date
    get_holidays
    fecha = 5.business_days.ago
    @expedients = Surgeries::File.joins(:sale_orders).where(orders: {expected_delivery_date: fecha})

    return if @expedients.empty?

    emails = [
      "Info@magnus.com.ar",
      "auxadministracion@magnus.com.ar", 
      "calfuquir.nico2@gmail.com",
      "mtg@grupoorange.com.ar"
    ]

    #ya_notificados = CxNotification.where(tipo: 'equipo_ventas', fileable_type: 'Expedient').pluck(:fileable_id)
    #@expedients = @expedients.reject { |e| ya_notificados.include?(e.id) }
    @expedients = @expedients.select { |e| e.surgical_sheet == "/images/attachment.png" }
    @expedients = @expedients.select { |e| e.implant_certificate == "/images/attachment.png" }
    
    return @expedients if @expedients.empty?  
    #CxNotification.create([@expedients.map { |expedient| { fileable: expedient, tipo: "equipo_ventas" } }])
    mail to: emails, subject: "Expedientes de CX  Vencidos y Sin documentación."
  end

  #envuiamos notificacion a los vendedores
  def send_sin_documentacion_to_vendedores_process
    existing_job = Delayed::Job.where("handler LIKE ?", "%send_sin_documentacion_to_vendedores_process%").first
    if !existing_job.present? 
      hora = (DateTime.now + 1.day).midnight + 20.5.hours
      Surgeries::ExpedientMailer.delay(run_at: hora).send_sin_documentacion_to_vendedores_process
    end
    get_holidays
    fecha = 5.business_days.ago
    @expedients = Surgeries::File.joins(:sale_orders).where(orders: {expected_delivery_date: fecha})
    #ya_notificados = CxNotification.where(tipo: 'equipo_ventas', fileable_type: 'Expedient').pluck(:fileable_id)
    #@expedients = @expedients.reject { |e| ya_notificados.include?(e.id) }
    @expedients = @expedients.select { |e| e.surgical_sheet == "/images/attachment.png" }
    @expedients = @expedients.select { |e| e.implant_certificate == "/images/attachment.png" }
    return if @expedients.empty?
    @grouped_expedients = @expedients.group_by{|file| file.sale_orders.map{|so| so.sellers.first }.uniq.first }
    return if @expedients.empty?
    @grouped_expedients.each do |seller, current_files|
      @current_files = current_files
      @current_seller = seller
      emails = [
        seller.try(:email),
        "calfuquir.nico2@gmail.com",
        "mtg@grupoorange.com.ar"
      ]
      send_sin_documentacion_to_vendedores(emails, seller, current_files).deliver
    end
  end

  def send_sin_documentacion_to_vendedores(emails, seller, current_files)
    mail to: emails, subject: "Expedientes de CX  Vencidos y Sin documentación."
  end

  def get_holidays
    from = Date.current - 30.day
    to = Date.current
    Holidays.between(from, to, :ar, :observed).map{|holiday| BusinessTime::Config.holidays << holiday[:date]}
  end
end
