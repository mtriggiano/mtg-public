module ClientManager
	class Importer
		def self.import_exel file, current_user
    		spreadsheet = open_spreadsheet(file)
    		excel = []
    		(2..spreadsheet.last_row).each do |r|
    				excel << spreadsheet.row(r)
    		end
    		header = self.permited_params
    		load_entity(excel, header, current_user)
		end

		def self.permited_params
		    [:denomination, :name, :document_number, :address]
		end

		def self.load_entity spreadsheet, header, current_user
			(0..spreadsheet.size - 1).each do |i|
				row = Hash[[header, spreadsheet[i]].transpose]
				client = Client.where(name: row[:name]).first_or_initialize
				client.denomination = row[:denomination]
				client.document_type = "80"
				client.document_number = row[:document_number]
				client.address = row[:address]
				client.company_id = current_user.company_id
				client.save
        		pp client.errors
			end
		end

		def self.open_spreadsheet(file)
		    case File.extname(file.original_filename)
			    when ".csv" then Roo::Csv.new(file.path)
			    when ".xls" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
			    when ".xlsx" then Roo::Excelx.new(file.path)
			    else raise "Tipo de archivo desconocido: #{file.original_filename}"
		    end
		end
	end
end
