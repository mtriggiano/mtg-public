class Surgeries::FileMovement < ExpedientMovement
	belongs_to :file, class_name: "Surgeries::File", foreign_key: :file_id
end