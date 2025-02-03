class HumanResources::PermissionsController < ApplicationController
  expose :permissions, -> {current_company.permissions}
  expose :permission, scope: -> {permissions}
  include Indexable
  include JustificationApprover

  def new
    # code
  end

  def edit
    # code
  end

  def create
    permission.company_id = current_company.id
    permission.creator_id = current_user.id
    if permission.save
      redirect_to permissions_path, notice: "#{permission.reason} creada con éxito"
    else
      pp permission.errors
      render :new
    end
  end

  def update
    # code
  end

  def destroy
    if permission.destroy
      redirect_to permissions_path, notice: "Se eliminó el registro con éxito"
    else
      render :index
    end
  end


  private

  def permission_params
    params.require(:permission).permit(:user_id, :attendant_id, :init_date, :days, :approved, :reason, :observation, :principal_attachment,
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
    )
  end

  def permission_approve_params
    params.require(controller_name.singularize.to_sym).permit(:reject_reason, :approver_id, :approved,
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
    )
  end
end
