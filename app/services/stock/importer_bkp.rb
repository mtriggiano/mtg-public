module Stock
	class ImporterBkp

		include Virtus.model()

		attribute :anmat, Anmat::Traceability

		def self.import_exel file, current_user
    		spreadsheet = open_spreadsheet(file)
    		excel = []
    		(2..spreadsheet.last_row).each do |r|
    				excel << spreadsheet.row(r)
    		end
    		header = self.permited_params
    		categories = {}
    		current_user.company.product_categories.each{|pc| categories[pc.name] = pc.id}
    		load_products(excel, header, categories, current_user)
				#load_products(excel, header, categories, current_user)
		end

		def self.import_anmat current_user, store_id
			@current_user = current_user
			@anmat = Anmat::Traceability.new()
			page = 1
			fill_database
		end

		def self.fill_database
			page = 1
			while page
				response = @anmat.consultar_stock({page: page, per_page: 100})
				page += 1
				if !response[:transacciones].blank?
					response[:transacciones].each do |unit|
					product_category = ProductCategory.where(name: "#{unit[:forma]} #{unit[:presentacion]}", company_id: @current_user.company_id).first_or_create
					product = Product.where(name: unit[:nombre], product_category_id: product_category.id).first_or_initialize
					product.measurement_unit 		= "7"
		    		product.product_type 			= "regular"
						product.type = "Product"
						unless product.save
							pp product.errors
						end
					end
				else
					page = false
				end
			end
		end

		def self.load_products spreadsheet, header, categories, current_user
			time = Time.now
			Product.where(id: [14051, 16036, 14449, 10594, 4314, 13090, 11814, 11815]).destroy_all
			invalid 	= []
			(0..spreadsheet.size - 1).each do |i|
	  			row = Hash[[header, spreadsheet[i]].transpose]
	  			row[:product_category_name] ||= "Sin categoría"
					row[:family] ||= "Sin subcategoría"
	    		if categories["#{row[:product_category_name]}"].nil?
	    			pc = ::ProductCategory.where(name: row[:product_category_name], company_id: current_user.company_id).first_or_initialize
					if pc.new_record?
						if pc.save
							product_category_id = pc.id
							categories["#{row[:product_category_name]}"] = product_category_id
						end
					else
						product_category_id = pc.id
						categories["#{row[:product_category_name]}"] = product_category_id
					end
	    		end
	    		product = ::Product.where("UPPER(products.code) = ?", row[:code].to_s.upcase).where("products.gtin IS NULL OR products.gtin = ?", row[:gtin].to_s).first_or_initialize
	    		product.product_category_id 	||= categories["#{row[:product_category_name]}"]
				product.family 					||= row[:family]
	    		product.code 				    = row[:code].to_s.upcase
	    		product.name 				    = row[:name].to_s.upcase
				product.pm						= row[:pm]
				product.branch					= row[:branch]
				product.source					= row[:source]
				product.pm						= row[:pm]
				product.gtin					= row[:gtin].to_s
	  			product.measurement_unit 		= ::Inventary::MEASUREMENT_UNITS.map{|k,v| k unless v.downcase != row[:measurement_unit].try(:downcase)}.compact.join()
	  			product.product_type 			= "regular"
				if !row[:serial].blank?
					product.available_stock 	+= 1
					if product.save
						product.batches.where(due_date: row[:due_date], code: row[:batch].to_s, serial: row[:serial].to_s).where("created_at < ?", time).update_all(quantity: 0, state: false)
						batch = Batch.where(product_id: product.id, due_date: row[:due_date], code: row[:batch].to_s, serial: row[:serial].to_s, state: true).first_or_initialize
						batch.quantity = 1
						invalid << [i, batch.errors] unless batch.save
					else
						invalid << [i, product.errors]
					end
				elsif !row[:batch].blank?
					new_stock = row[:available_stock].blank? ? 1 : row[:available_stock].to_i
					product.available_stock += new_stock
					if product.save
						product.batches.where(code: row[:batch].to_s, due_date: row[:due_date]).where("created_at < ?", time).update_all(quantity: 0, state: false)
						batch = Batch.where(product_id: product.id, due_date: row[:due_date], code: row[:batch].to_s).first_or_initialize
						batch.quantity = new_stock
						batch.state = batch.quantity > 0
						invalid << [i, batch.errors] unless batch.save
					else
						invalid << [i, product.errors]
					end
				else
					product.available_stock 	= row[:available_stock].to_i
					product.save
				end
				article = product.articles.where(store_id: 3).first_or_initialize
				article.available = product.available_stock
				invalid << [i, article.errors] unless article.save
	    	end
	    	pp invalid
			return_process_result(invalid, current_user)
		end

	    def self.return_process_result invalid, user
	      if invalid.any?
	        {
	          'result' => false,
	          'message' => 'Uno o mas productos no pudieron importarse.',
	          'product_with_errors' => invalid
	        }
	      else
	        {
	          'result' => true,
	          'message' => 'Todos los productos fueron correctamente importados a la base de datos.',
	          'product_with_errors' => []
	        }
	      end
	    end

		def self.permited_params
		    [:product_category_name, :family, :code, :name, :branch, :source, :available_stock, :pm, :gtin,:batch,:serial, :due_date]
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
