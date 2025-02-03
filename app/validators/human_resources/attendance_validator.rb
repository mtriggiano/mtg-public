module AttendanceValidator
	extend ActiveSupport::Concern

	included do
    validates_presence_of :user_id, message: 'El empleado no puede estar en blanco'
    #validate :multiple_attendances, on: :create
  end

  def multiple_attendances

    user_day_atts = user.attendances.where(date: date).order("attendances.date ASC")
    if user_day_atts.blank?
      return true
    else
      last_att = user_day_atts.last
      if (last_att.justification_label == "Presente" && !last_att.check_in.nil?) && (self.check_in.nil?) && (self.minute_between_atts_calc(last_att))
        errors.add("Multiple marcaje", "Ya existe asistencias en este horario")
      elsif (["Vacaciones", "Permiso", "Justificado", "Injustificado"].include?(last_att.justification_label))
        last_att.destroy
      else
        pp last_att.justification_label
      end
    end
  end

  def minute_between_atts_calc last_att
    min_15_calc = last_att.check_in - 15.minutes
    max_15_calc = last_att.check_in + 15.minutes
    band = false
    if (min_15_calc <= self.check_in && self.check_in <= max_15_calc)
      band = true
    else
      band =  false
    end
    return band
  end

end
