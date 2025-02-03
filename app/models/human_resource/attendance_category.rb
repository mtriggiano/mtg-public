class AttendanceCategory < ApplicationRecord
  has_many :attendance_category_users, dependent: :destroy
  has_many :users, through: :attendance_category_users
  # accepts_nested_attributes_for :attendance_category_turns, allow_destroy: true

  def self.search search
    if !search.blank?
      where("UPPER(name) ILIKE ?", "%#{search.upcase}%")
    else
      all
    end
  end

  # def turns
  #   working_days + ". Entrada: " + check_in.to_time.strftime("%H:%M") + " Salida: " + check_out.to_time.strftime("%H:%M")
  # end
  #
  # def short_turns
  #   short_working_days + ". De: " + check_in.to_time.strftime("%H:%M") + " A: " + check_out.to_time.strftime("%H:%M")
  # end

  def working_days
    days = []
    days << ["Lunes"] if monday
    days << ["Martes"] if tuesday
    days << ["Miércoles"] if wednesday
    days << ["Jueves"] if thursday
    days << ["Viernes"] if friday
    days << ["Sábado"] if saturday
    days << ["Domingo"] if sunday
    days.join(", ")
  end

  def english_working_days
    days = []
    days << "Monday" if monday
    days << "Tuesday" if tuesday
    days << "Wednesday" if wednesday
    days << "Thursday" if thursday
    days << "Friday" if friday
    days << "Saturday" if saturday
    days << "Sunday" if sunday
    days
  end

  def short_working_days
    days = []
    days << "LUN" if monday
    days << "MAR" if tuesday
    days << "MIE" if wednesday
    days << "JUE" if thursday
    days << "VIE" if friday
    days << "SAB" if saturday
    days << "DOM" if sunday
    days.join(", ")
  end

  def expected_worked_hours
    ewh = 0
    ewh = (check_out.to_time - check_in.to_time).to_f / 3600
    ewh
  end

  def cant_working_days
    days = []
    days << ["Lunes"] if monday
    days << ["Martes"] if tuesday
    days << ["Miércoles"] if wednesday
    days << ["Jueves"] if thursday
    days << ["Viernes"] if friday
    days << ["Sábado"] if saturday
    days << ["Domingo"] if sunday
    days.count
  end

  # Devolvemos ID de categoria segun check_in y check_out
  def set_category check_in, check_out
    if !check_out.blank?
      # pasamos check_in y check_out a horario LOCAL
      # check_in -= 3.hours
      # check_out -= 3.hours

      # if (self.check_in + self.late.minutes >= check_in.to_time) && (self.check_out - self.early.minutes <= check_out)
      #  pp "SI ENCONTRO CATEGORIA"
      #  return self.id
      if ((self.check_in - 30.minutes) <= check_in.to_time) && (self.check_out > check_in.to_time)
        return id
      else
        return nil
      end
    else
      nil
    end
  end

  def self.set_category categories, compare_check_in, date
    r_category = nil
    categories.order(:check_in).map{|a| a if a.english_working_days.include?(Date::DAYNAMES[date.wday].capitalize)}.compact.each do |category|
      cat_check_in = Time.new(2000, 1, 1, category.check_in.hour, category.check_in.min)
      cat_check_out = Time.new(2000,1,1, category.check_out.hour, category.check_out.min)
      # pp category.id
      # pp compare_check_in.to_time
      # pp (((cat_check_in) <= compare_check_in.to_time) || (cat_check_in >= compare_check_in.to_time))
      # pp (cat_check_out > compare_check_in.to_time)
      # pp "----------------------------------"
      # El check-in del usuario debe ser MENOR al check_in de la categoría - 30 minutos | y el checkout de la categoría debe ser mayor a el check_in del usuario (para que no se solapen horarios)

      if (((cat_check_in) <= compare_check_in) || (cat_check_in >= compare_check_in))
        if (cat_check_out > compare_check_in)
          r_category = category
          break
        end
      else
        r_category = nil
      end
    end
    return r_category
  end


end
