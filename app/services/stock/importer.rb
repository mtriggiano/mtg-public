module Stock
	class Importer
		attr_accessor :file, :company, :spreadsheet, :first_row, :data, :product, :category, :row, :start_time

		def initialize(file:, company:)
			@file = file
			@company = company
			@start_time = Time.now
		end

		def import
			prepare_spreadsheet
			populate_database
		end

		private

			def prepare_spreadsheet
				@spreadsheet = open_spreadsheet
			end

			def open_spreadsheet
				case File.extname(file.original_filename)
					when ".csv" then Roo::Csv.new(file.path)
					when ".xls" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
					when ".xlsx" then Roo::Excelx.new(file.path)
					else raise "Tipo de archivo desconocido: #{file.original_filename}"
				end
			end

			def header
				[:product_category_name, :family, :code, :name, :branch, :source, :available_stock, :pm, :gtin,:batch,:serial, :due_date]
			end

			def map_products
				(2..@spreadsheet.last_row - 1).each do |row|
					@row = row
					yield set_data(row)
				end
			end

			def set_data(row)
				@data = OpenStruct.new(Hash[[header, @spreadsheet.row(row)].transpose])
			end


			def populate_database
				Product.transaction do
					map_products do |data|
						get_product
						get_category
						change_product
						save_product
					end
				end
			end

			def get_category
				@category = company.product_categories.where(name: @data.product_category_name).first_or_create
			end

			def get_product
				@product = company.products.where("UPPER(code) = UPPER(?)", @data.code.to_s.upcase).first_or_initialize
			end

			def change_product
				@product.product_category_id 	= @category.id
				@product.family 				= @data.family
				@product.name 					= @data.name.upcase
				@product.pm						= @data.pm
				@product.branch					= @data.branch
				@product.source					= @data.source
				@product.pm						= @data.pm
				@product.gtin					= @data.gtin
				destroy_batches
				change_batches
				change_articles
			end

			def change_batches

				unless @data.batch.blank? && @data.serial.blank?
					batch 			= get_batch
					batch.code 		= @data.batch.to_s.upcase unless @data.batch.blank?
					batch.serial 	= @data.serial.to_s.upcase unless @data.serial.blank?
					batch.due_date 	= @data.due_date
					batch.quantity 	= @data.available_stock.to_i
					batch.state 	= @data.available_stock.to_i > 0
					batch.imported = true

					@product.batches_attributes = batch.attributes
				end
			end

			def destroy_batches
			  batches_a_borrar = @product.batches.where(imported: false)
				batches_a_borrar.update_all(state: false)
			end

			def get_batch
				if !@data.batch.blank? && !@data.serial.blank?
					Batch.where(product_id: @product.id).where("UPPER(code) = UPPER(?) AND UPPER(serial) = UPPER(?)", @data.batch.to_s.upcase, @data.serial.to_s.upcase).first_or_initialize
				elsif @data.batch.blank? && !@data.serial.blank?
					Batch.where(product_id: @product.id).where(" UPPER(serial) = UPPER(?)", @data.serial.to_s.upcase).first_or_initialize
				else
					Batch.where(product_id: @product.id).where(" UPPER(code) = UPPER(?)", @data.batch.to_s.upcase).first_or_initialize
				end
			end

			def change_articles
				article = @product.articles.find_by(store_id: 3)
				@product.available_stock =  @product.batches.select{|b| b.state }.sum(&:quantity)
				@product.articles_attributes = { 0 => {id: article&.id, store_id: 3, available: @product.available_stock.to_i} }
			end

			def save_product
				raise StandardError.new(@product.errors.full_messages) unless @product.save
			end
	end
end
