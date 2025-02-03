module BankAccountsManager
  class BankAccountTransactionLoader < ApplicationService
    attr_accessor :bank_account, :file

    EXTENSIONES_PERMITIDAS = %w(.csv .xls .xlsx)

    FILAS_ENCABEZADO = 1

    POSICIONES_ATRIBUTOS = {
      :fecha => "1",
      :descripcion => "2",
      :debito => "4",
      :credito => "5",
      :saldo => "6"
    }

    def initialize(bank_account, file)
      @bank_account = bank_account
      @file = file
    end

    def call
      ActiveRecord::Base.transaction do
        if extension_correcta?
          archivo = abrir_archivo_segun_extension
          filas   = vector_de_filas(archivo)
          registra_transacciones(filas)
        end
      end
    end

    private

    def extension_correcta?
      extension = File.extname(file.original_filename)
      unless EXTENSIONES_PERMITIDAS.include?(extension)
        bank_account.errors.add(:base, "El tipo de archivo importado es incorrecto. Formatos esperados: [ #{EXTENSIONES_PERMITIDAS.join(" ")} ].")
        return false
      end
      true
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
      cantidad_de_columnas = vector_de_filas.first.size
      atributos, monto_unico = arregla_vector_de_atributos(cantidad_de_columnas)
      pp atributos
      vector_de_filas.each_with_index do |fila, index|
        registro = Hash[[atributos, fila].transpose]
        if monto_unico
          registro[:amount] ||= 0
        else
          registro[:credito] ||= 0
          registro[:debito]  ||= 0
        end
        pp registro

        # if registro_no_repetido?(registro, monto_unico)
          if registro_valido?(registro)
            transaccion = nueva_transaccion(registro, monto_unico)
            unless transaccion.save
              transaccion.errors.each do |name, message|
                bank_account.errors.add(:base, "Error: #{name} #{message}")
              end
            end
          else
            bank_account.errors.add(:base, "El registro de la fila #{index + 1} es inválido")
          end
        # else
        #   bank_account.errors.add(:base, "El registro de la fila #{ index + 1 } se encuentra repetido.")
        # end
      end
    end

    def arregla_vector_de_atributos(longitud_vector)
      vector_de_atributos = Array.new(longitud_vector)
      monto_unico = false
      if bank_account.configuration
        vector_de_atributos[bank_account.configuration.fecha.to_i - 1]       = :fecha
        vector_de_atributos[bank_account.configuration.descripcion.to_i - 1] = :descripcion
        vector_de_atributos[bank_account.configuration.saldo.to_i - 1]       = :saldo
        if bank_account.configuration.amount_column_type_unique
          vector_de_atributos[bank_account.configuration.amount.to_i - 1]      = :monto
          monto_unico = true
        else
          vector_de_atributos[bank_account.configuration.credito.to_i - 1]     = :credito
          vector_de_atributos[bank_account.configuration.debito.to_i - 1]      = :debito
        end
      else
        ## genero un vector que tenga cada atributo en la posición indicada (-1)
        ## EJ: vector_de_atributos => [":fecha", ":descripcion", ":debito", ":credito", nil, ":saldo", nil, nil, nil]
        POSICIONES_ATRIBUTOS.each { |key, value| vector_de_atributos[value.to_i - 1] = key }
      end

      return vector_de_atributos, monto_unico
    end

    def registro_no_repetido?(registro, monto_unico)
      if monto_unico
        monto = registro[:monto].to_s.gsub(".", "").to_f
        if monto > 0
          debito = monto.abs
          credito = 0
        else
          debito = 0
          credito = monto.abs
        end
      else
        debito = registro[:debito].to_s.gsub(".", "").to_f
        credito = registro[:credito].to_s.gsub(".", "").to_f
      end
      transaccion = bank_account.transactions.where(fecha: registro[:fecha], descripcion: registro[:descripcion], debito: debito, credito: credito)
      return false unless transaccion.empty?
      true
    end

    def registro_valido?(registro)
      !(registro[:fecha].blank? || registro[:descripcion].blank?)
    end

    def nueva_transaccion(registro, monto_unico)

      transaccion = bank_account.transactions.new.tap do |tr|
        tr.fecha = registro[:fecha]
        tr.descripcion = registro[:descripcion]
        tr.imported = true
        if monto_unico
          monto = registro[:monto].to_s.gsub(".", "").to_f
          if monto > 0
            tr.debito = monto.abs
            tr.credito = 0
          else
            tr.credito = monto.abs
            tr.debito = 0
          end
        else
          tr.credito = registro[:credito].to_s.gsub(".", "").to_f
          tr.debito = registro[:debito].to_s.gsub(".", "").to_f
        end
        tr.saldo = registro[:saldo].to_s.gsub(".", "").to_f
      end
      return transaccion
    end

  end
end
