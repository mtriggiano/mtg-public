class HumanResources::UsersController < ApplicationController
  before_action :set_s3_direct_post, only: [:edit]
  expose :users, -> {current_company.users.actives}
  expose :user, scope: -> {users}
  include Indexable
  include Alertable

  def new
    # code
  end

  def edit
    # code
  end

  def create
    # code
  end

  def update
    if user.update(user_params)
      redirect_to edit_user_path(view: params[:view]), notice: "Actualizacion exitosa"
    else
      render :edit
    end
  end

  def set_role
    if user.update(user_params)
      redirect_to user_user_roles_path(user.id), notice: "Actualizacion exitosa"
    else
      render :show
    end
  end

  def profile

  end


  def month_comissions
    render json: ChartManager::UserChartDataObtainer.new(user, true, params[:init_date].to_date, params[:final_date].to_date).get_month_list
  end

  def client_comissions
    render json: ChartManager::UserChartDataObtainer.new(user, true, params[:init_date].to_date, params[:final_date].to_date).get_client_list
  end

  def month_comissions_quantity
    render json: ChartManager::UserChartDataObtainer.new(user, true, params[:init_date].to_date, params[:final_date].to_date).perform
  end

  def client_comissions_quantity
    render json: ChartManager::UserChartDataObtainer.new(user, true, params[:init_date].to_date, params[:final_date].to_date).get_client_list_quantity
  end

  private

  def user_params
    params.require(:user).permit(:email, :active, :avatar, :first_name, :file_number, :last_name, :document_type, :document_number, :birthday, :address, :postal_code, :phone, :mobile_phone, :machine_id, :start_of_activity, :talliable, :contract, :work_station_id, :social_work, :bill_due_notification, :password, :password_confirmation,
      debt_vacations_attributes: [:id, :year, :days, :_destroy],
      role_ids: [],
      user_comission_limit_attributes: [:id, :amount, :period, :_destroy],
      user_comission_rewards_attributes: [:id, :reward_percentage, :percentage, :_destroy],
      attendance_category_users_attributes: [:id, :attendance_category_id, :_destroy],
    )
  end

end
