class Surgeries::Prescription < ExpedientRequest
	include Notificable
	TYPES  = Surgeries::File::TYPES
	belongs_to :file, class_name: "Surgeries::File", foreign_key: "file_id"

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

	def to_s
		"Receta Nº #{number}"
	end
end
