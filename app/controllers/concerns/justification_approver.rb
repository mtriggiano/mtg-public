module JustificationApprover
	extend ActiveSupport::Concern

	included do
		before_action :set_s3_direct_post, only: [:set_approve_params, :approve, :show, :new, :edit, :create, :update]
	end

  def set_approve_params
    # code
  end

  def approve
    record.approver_id = current_user.id
    if record.update(eval("#{record.class.name.snakecase}_approve_params"))
      redirect_to eval("#{controller_name}_path"), notice: "Aprobado correctamente"
    else
      redirect_to eval("#{controller_name}_path"), notice: "Error al aprobar. Intente nuevamente"
    end
  end

  private
		def record
			eval(controller_name.singularize)
		end

end
