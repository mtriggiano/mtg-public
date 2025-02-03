module AttendanceManager
  class Importer

    attr_accessor :file

    EXTENSIONES_PERMITIDAS = %w(.csv .xls .xlsx)

    FILAS_ENCABEZADO = 1

    def initialize(file)
      @file = file
    end

    def call
      ActiveRecord::Base.transaction do
        begin
          if extension_correcta?
            archivo = abrir_archivo_segun_extension
            filas   = vector_de_filas(archivo)
            registra_transacciones(filas)
            AttendanceManager::ResumeGenerator.new.perform
            return "true"
          end
        rescue ActiveModel::MissingAttributeError => e
          return "Seleccione un archivo"
        rescue ArgumentError => e
          return "El tipo de archivo importado es incorrecto. Formatos esperados: [ #{EXTENSIONES_PERMITIDAS.join(" ")} ]."
        rescue ActiveRecord::ActiveRecordError => e
          return "Error al guardar los registros de asistencia. Mensaje: #{e.message}"
        rescue Exception => e
          return "Error al importar archivos: #{e.message}"
        end
      end
    end

    private

    def extension_correcta?
      unless file.nil?
        extension = File.extname(file.original_filename)
        unless EXTENSIONES_PERMITIDAS.include?(extension)
          raise ArgumentError
          return false
        end
        true
      else
        raise ActiveModel::MissingAttributeError
      end
    end

    def abrir_archivo_segun_extension
      case File.extname(file.original_filename)
      when ".csv"
        Roo::CSV.new(file.path, csv_options: {encoding: Encoding::ISO_8859_1, col_sep: ";"})
      when ".xls"
        Roo::Spreadsheet.open(file.path, extension: :xls)
      when ".xlsx"
        Roo::Excelx.new(file.path)
      end
    end

    def vector_de_filas(archivo)
      vector_archivo = []
      (FILAS_ENCABEZADO + 1..archivo.last_row).each do |r|
        vector_archivo << archivo.row(r)
      end
      return vector_archivo
    end

    def registra_transacciones(vector_de_filas)
      atributos = [:user_id, :date]
      vector_de_filas.each_with_index do |fila, index|
        registro = Hash[[atributos, fila].transpose]
        user = User.where(machine_id: registro[:user_id].to_i).first
        # Obtenemos las asistencias del día
        if !user.nil? && user.status == "Activo"
          last_att = user.attendances.where(date: registro[:date].to_date, check_out: nil).where.not(check_in: nil).last
          if last_att.nil?
            build_new_att(registro, user)
          else
            set_checkout(registro, last_att)
          end
        else
          pp "no se encuentra el usuario"
        end
      end
    end


    def build_new_att(registro, user)
      att_check_in = Time.new(2000,1, 1, registro[:date].to_time.hour, registro[:date].to_time.min)
      new_att = user.attendances.where(date: registro[:date].to_date, check_in: att_check_in).first_or_initialize
      new_att.present = true
      new_att.justified = false
      new_att.vacation = false
      new_att.check_in = att_check_in
      new_att.minutes_late = 0
      new_att.attendance_resume_id = nil
      if new_att.save
        pp "attendance creada correctamente"
        new_att.check_if_late
      else
        pp "Attendance duplicada"
      end
    end

    def set_checkout registro, last_att
      if I18n.l(registro[:date].to_datetime, format: :time) >= I18n.l((last_att.check_in + 15.minutes).to_datetime, format: :time)
        #new_att = user.attendances.where(date: registro[:date].to_date, check_out: nil).where.not(check_in: nil).last
        att_check_out = Time.new(2000,1, 1, registro[:date].to_time.hour, registro[:date].to_time.min)
        last_att.check_out = att_check_out
        work_time = ((last_att.check_out.to_time - last_att.check_in.to_time).to_f / 3600)
        work_time = if work_time % 1 < 0.5
          work_time.round(0)
        else
          work_time.round(1)
        end
        last_att.work_time = work_time
        last_att.save
        last_att.check_if_early
      else
        last_att.work_time = 0
        last_att.save
      end
    end

  end
end
