class Reports::BillDetailsController < ApplicationController
  load_and_authorize_resource class: 'Reports::BillDetail', except: [:index]
  skip_load_and_authorize_resource only: [:index]

  def index
    authorize! :access, :reports

    @can_see_all_sellers = current_user.can_see_all_sellers
    render json: Reports::BillDetailDatatable.new(params, view_context: view_context, collection: bill_details), status: 200
  end

  private

  def bill_details
    @bill_details ||= current_company.sale_bill_details.select_real_total
  end
end
