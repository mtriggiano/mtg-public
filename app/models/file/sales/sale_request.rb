class Sales::SaleRequest < ExpedientRequest
  	include Notificable
	TYPES  = Sales::File::TYPES
	belongs_to :file, class_name: "Sales::File", foreign_key: "file_id"

	after_save :touch_file, if: :approved?

	def self.search number
		if not number.blank?
			where("#{table_name}.number ILIKE ?", "%#{number}%")
		else
			all
		end
	end

	def touch_file
		file.touch
	end

	def department
		"Ventas"
	end

  def has_pdf?
    false
  end
end
