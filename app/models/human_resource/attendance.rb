class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :attendance_resume, optional: true
  belongs_to :justificable, polymorphic: true, optional: true

  has_many :observations, class_name: 'AttendanceObservation'
  has_one :non_present_user
  accepts_nested_attributes_for :observations, reject_if: :all_blank, allow_destroy: true

  default_scope {where(active: true)}

  after_save :set_present_label

  include AttendanceValidator

  JUSTIFICATION_LABELS = [
    "Presente",
    "Injustificado",
    "Ausente por llegada tarde",
    "Suspendido",
    "Enfermo",
    "Vacaciones",
    "Justificado"
  ]

  def destroy
    self.update_columns(active: false)
  end

  def set_present_label
    if present
        update_columns(present_label: "Presente", justification_label: justification_type)
    else
        update_columns(present_label: "Ausente", justification_label: justification_type)
    end

  end

  def justification_type
    # user_atts = attendances del día

    presente = self.present
    justification = (self.justificable_type == "Permission")
    vacations = (self.justificable_type == "UserVacation") # si devuelve tuplas significa que está de vacaciones

    if !presente
      if vacations
        return "En vacaciones"
      end
      if justification
        return self.justificable.reason
      end
      if late_alert
        return "Ausente por llegada tarde"
      end
      return "Injustificado"
    else
      return "Presente" # presente
    end
  end

  def self.create_justified_attendances user, type_of_justification, date, days, object
    AttendanceManager::Justifier.new(user, type_of_justification, date, days, object).perform
  end

  def check_if_early
    if !check_out.blank? && justificable_id.nil?
      compare_check_in = Time.new(2000, 1, 1, check_in.hour, check_in.min)
      compare_check_out = Time.new(2000, 1, 1, check_out.hour, check_out.min)
      at_present = self.present
      category = user.attendance_categories.blank? ? nil : AttendanceCategory.set_category(user.attendance_categories, compare_check_in, self.date) #obtener categoria
      early_alert = false
      unless category.nil?
        cat_check_out = Time.new(2000, 1, 1, category.check_out.hour, category.check_out.min)
        if compare_check_out < (cat_check_out - 5.minutes)
          at_present = false
          early_alert = true
          update_columns(present: at_present, early_alert: early_alert)
          set_present_label
        end
      end
    end
  end

  def check_if_late
    if !check_in.blank? && justificable_id.nil?
      compare_check_in = Time.new(2000, 1, 1, check_in.hour, check_in.min)

      at_present = self.present
      category = user.attendance_categories.blank? ? nil : AttendanceCategory.set_category(user.attendance_categories, compare_check_in, self.date) #obtener categoria

      unless category.nil?
        cat_check_in = Time.new(2000, 1, 1, category.check_in.hour, category.check_in.min)
        cat_check_out = Time.new(2000, 1, 1, category.check_out.hour, category.check_out.min)
        if compare_check_in >= (cat_check_in + category.late.minutes)
          at_present = false
          at_late_alert = true
          at_minutes_late = ((compare_check_in - cat_check_in) / 1.minutes).to_i
          at_no_category_alert = true
        elsif compare_check_in >= (cat_check_in + 5.minutes)
          at_late_alert = true
          at_minutes_late = ((compare_check_in - cat_check_in) / 1.minutes).to_i
          at_present = true
        else
          at_late_alert = false
          at_no_category_alert = false
          at_minutes_late = 0.0
          at_present = true
        end

      else
        at_no_category_alert = true
        at_late_alert = false
        at_present = true
        at_minutes_late = 0.0
      end

      update_columns(no_category_alert: at_no_category_alert, late_alert: at_late_alert, minutes_late: at_minutes_late, present: at_present)
      set_present_label
    else
      false
    end
  end




end
