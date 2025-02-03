class HumanResources::NonWorkingDayDetailsController < ApplicationController
  expose :non_working_day, scope: -> {current_company.non_working_day_details.find(params[:id])}

  def destroy
    #@non_working_day_detail = NonWorkingDayDetail.find(params[:id])
    non_working_day_detail.destroy
    respond_to do |format|
      format.html { redirect_to non_working_days_url, notice: "Eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

end
