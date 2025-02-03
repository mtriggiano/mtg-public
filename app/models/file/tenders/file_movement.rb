class Tenders::FileMovement < ExpedientMovement
	belongs_to :file, class_name: "Tenders::File", foreign_key: :file_id
end