module BillManager
	class Exporter
		attr_accessor :bill
    require('zip')
    def initialize(bill)
      @bill = bill
    end

    def export
      filename = "#{bill.full_name}.zip"
      temp_file = Tempfile.new(filename)

      begin
        Zip::OutputStream.open(temp_file) { |zos| }

        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
          file = Tempfile.new("#{bill.client.document_number}_#{bill.cbte_tipo}_#{bill.sale_point}_#{bill.number}.txt")
          file.write(cabecera)
					file.close
          zip.add("#{bill.client.document_number}_#{bill.cbte_tipo}_#{bill.sale_point}_#{bill.number}.txt", file.path)
        end

        zip_data = File.read(temp_file.path)
        return zip_data, filename
      ensure # important steps below
        temp_file.close
        temp_file.unlink
      end
    end

    def cabecera
      text = "1"
			text << bill.date.strftime("%Y%m%d")
			text << bill.cbte_tipo
      text << "C"
			text << bill.sale_point.rjust(4, '0')
			text << bill.number.rjust(8, '0')
			text << bill.number.rjust(8, '0')
			text << (bill.details.count / 14) + (bill.details.count % 14 > 0 ? 1 : 0)
      text << bill.document_type.to_s #VERIFICAR EN CIRUGIAS
      text << bill.document_number.to_s
			text << bill.client.name.upcase[0..30].ljust(30,' ')
			text << to_15(bill.total)
			text << to_15(bill.total - bill.imp_neto)
			text << to_15(bill.imp_neto)
			text << to_15(bill.iva_amount)
			text << to_15(bill.tributes.where(afip_id: "13").sum(:amount))
			text << to_15(bill.imp_op_ex.to_s)
			text << to_15(bill.tributes.where(afip_id: "1").sum(:amount))
			text << to_15(bill.tributes.where(afip_id: "7").sum(:amount))
			text << to_15(bill.tributes.where(afip_id: "3").sum(:amount))
			text << to_15(bill.tributes.where(afip_id: "4").sum(:amount))
			text << "000000000000000"
			text << Company::TIPO_RESPONSABLE.rassoc(bill.client.iva_cond).first
			text << "PES"
			text << "0001000000"
			text << bill.details.pluck(:iva_aliquot).uniq.size
			text << cod_operacion
			text << bill.cae
			text << bill.cae_due_date
			return text
    end

		def to_15(number)
			entero = number.to_i
			if entero == 0
				decimales = number.round(2) * 100
			else
				decimales = (number.to_i % entero.to_i).round(2) * 100
			end
			return "#{entero.to_s.rjust(13, '0')}#{decimales.to_i.to_s}"
		end

		def cod_operacion
			if bill.iva_amount == 0 && (bill.total - bill.imp_neto != 0)
				"E"
			else
				return " "
			end
		end
  end
end
