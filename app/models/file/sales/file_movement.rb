class Sales::FileMovement < ExpedientMovement
	belongs_to :file, class_name: "Sales::File", foreign_key: :file_id
end