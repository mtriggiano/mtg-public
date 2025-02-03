module UserManager
  class VacationCalculator

    def initialize user
      @user = user
    end

    def perform
      return vacation_calc
    end

    private

    def vacation_calc
      vacation = 0
      unless start_of_activity.blank?
        time_difference = Time.diff(start_of_activity, Time.now)
        dif_in_months = time_difference[:month] + (time_difference[:week] / 4).to_i
        dif_in_days = time_difference[:day] + (time_difference[:week] * 7).to_i
        ### 5 años = 60 meses
        ### 10 años = 120 meses
        ### 20 años = 240 meses
        if (dif_in_months < 6)
          vacation = (dif_in_days / 20).to_i
        elsif (dif_in_months >= 6 && dif_in_months < 60)
          vacation = 14
        elsif (dif_in_months >= 60 && dif_in_months < 120)
          vacation = 21
        elsif (dif_in_months >= 120 && dif_in_months < 240)
          vacation = 28
        elsif (dif_in_months >= 240)
          vacation = 35
        else
          vacation = 0
        end
        vacaciones_tomadas = user_vacations.joins(days_asignations: :user_debt_vacation).where(user_debt_vacations: {year: Time.now.year})
        unless vacaciones_tomadas.blank?
          vacation -= vacaciones_tomadas.sum(:days)
        end
      else
        vacation = 0
      end
      current_year_vacations = user.debt_vacations.where(year: Time.now.year).first_or_initialize
      current_year_vacations.days = vacation < 0 ? 0 : vacation
      current_year_vacations.save
      return vacation
    end
  end
end
