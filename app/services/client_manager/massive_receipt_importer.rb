module ClientManager
  class MassiveReceiptImporter
    attr_accessor :file, :client_id, :date, :current_user

    EXTENSIONES_PERMITIDAS = %w(.xls .xlsx)

    FILAS_ENCABEZADO = 1

    def initialize(file, client_id, date, current_user)
      @file = file
      @client_id = client_id
      @date = date
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
      begin
          if extension_correcta?
            archivo = abrir_archivo_segun_extension
            filas   = vector_de_filas(archivo)
            registra_transacciones(filas)
            return "true"
          end
        rescue ActiveModel::MissingAttributeError => e
          return "Seleccione un archivo"
          raise ActiveRecord::Rollback
        rescue ArgumentError => e
          return "El tipo de archivo importado es incorrecto. Formatos esperados: [ #{EXTENSIONES_PERMITIDAS.join(" ")} ]."
          raise ActiveRecord::Rollback
        rescue ActiveRecord::ActiveRecordError => e
          return "Error al guardar los registros. Mensaje: #{e.message}"
          raise ActiveRecord::Rollback
        rescue Exception => e
          return "Error al guardar los registros. Mensaje: #{e.message}"
          raise ActiveRecord::Rollback
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
      #atributos = [:fecha, :codigo_interno, :codigo_de_la_marca, :subrubro, :modelo, :variedad, :extra_data, :marca, :vto, :precio, :etiquetable, :entrada, :unidad, :estanteria, :estante, :retira, :maquina, :obs ]
      atributos = [:punto_venta, :number, :total]
      total_recibo = 0
      recibo = ExpedientReceipt.new(
        company_id: 3,
        user_id: current_user.id,
        current_user: current_user,
        receipt_type: "massive",
        total: 0,
        entity_id: @client_id,
        state: "Pendiente",
        date: date
      )
      recibo.save

      vector_de_filas.each_with_index do |fila, index|
        registro = Hash[[atributos, fila].transpose]
        bill = ExpedientBill.approveds.where(company_id: 3, entity_id: @client_id).where("CAST(bills.sale_point as int) = :sale_point AND CAST(bills.number as int) = :number", sale_point: registro[:punto_venta].to_i, number: registro[:number].to_i).first
        unless bill.nil?
          recibo.receipt_details.where(
            bill_id: bill.id,
            total: registro[:total].to_f
          ).first_or_create
          total_recibo += registro[:total].to_f
        end
      end
      recibo.update_columns(total: total_recibo)
      #Notification::ExpedientReceipt.new(recibo, current_user, [current_user.id]).for_created

    end



  end
end
