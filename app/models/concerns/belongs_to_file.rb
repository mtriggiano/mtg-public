module BelongsToFile
	extend ActiveSupport::Concern

	class_methods do
		def search number
			if not number.blank?
				where("#{table_name}.number ILIKE ?", "%#{number}%")
			else
				all
			end
		end

		def parent_klass
			file_class_name.snakecase.gsub("/", "_")
		end

		def parent_klass_foreign_key
			"#{parent_klass}_id".to_sym
		end

		def belongs_to_file(file_id)
			if not file_id.blank?
				eval("where(#{parent_klass}_id: file_id)")
			else
				all
			end
		end
	end

	included do
		include Virtus.model(constructor: false, mass_assignment: false)
    	include CustomAttributes
    	include HasAttachments
    	include Restricted
    	include HasDetails
    	include Numerable
    	include Reopener

    	def self.default_scope
    		where.not(parent_klass_foreign_key.to_sym => nil)
    	end

		def self.file_class_name
			name.split(/(?=[A-Z])/)[0] << "File"
		end

		def self.short_class_name
			name.gsub(name.split(/(?=[A-Z])/)[0], "").snakecase
		end

  		attribute  				:current_user, User
		validate				:must_belongs_to_file
		validate 			    :file_must_be_opened
		belongs_to 				:user
		belongs_to 				:company
		belongs_to 				:file, class_name: "Expedient", optional: true, foreign_key: parent_klass_foreign_key
		belongs_to 				parent_klass.to_sym, optional: true
		after_save 				:touch_file

		def self.inherited(child_class)
		    child_class.class_eval do
        	belongs_to 				:file, class_name: "Expedient", optional: true, foreign_key: parent_klass_foreign_key
  				belongs_to 				parent_klass.to_sym, optional: true
  				has_many   				:details,    class_name: "#{name}Detail", dependent: :destroy, foreign_key: "#{self.table_name.singularize}_id"
		    end
		    super
		end

		define_method(short_class_name.pluralize) do
			self.persisted? ? [self] : []
		end
	end

	def parent_type
		self.class.name.snakecase.split("_")[0]
	end

	def touch_file
		file.touch
	end

	def file_must_be_opened
		if file.disabled?
			case self.class.parent_klass
			when 'sale_file'
				errors.add(:sale_file_id, "El expediente seleccionado esta cerrado.")
			when 'purchase_file'
				errors.add(:purchase_file_id, "El expediente seleccionado esta cerrado.")
			when 'surgery_file'
				errors.add(:surgery_file_id, "El expediente seleccionado esta cerrado.")
			end
		end
	end

	def responsables
		file.responsables.where(document_type: self.class.name)
	end

	def must_belongs_to_file
		errors.add("#{self.class.parent_klass}_id".to_sym, "El documento debe pertenecer a un expediente.") if file.nil?
	end

end
