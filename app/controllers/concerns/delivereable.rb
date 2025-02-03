module Delivereable
	extend ActiveSupport::Concern

  def deliver
    klass = record.class.name + "Mailer"
    klass.constantize.send_to(record, params[:email]).deliver
    path = controller_path.split("/").join("_").singularize
		redirect_to eval("edit_#{path}_path(#{record.id})"), notice: "El comprobante fue enviado con éxito"
	end

	private

  def record
    eval(controller_name.singularize)
  end

  def set_current_user
    record.current_user = current_user
  end
end
