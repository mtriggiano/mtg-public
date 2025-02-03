class Purchases::FileMovement < ExpedientMovement

    belongs_to :file, class_name: 'Purchases::File', foreign_key: :file_id
    default_scope ->{where(file_type: "Purchases")}

    def self.set_initial_department(purchase_file)
    	movement 				= where(file_id: purchase_file.id).first_or_initialize
  		movement.department_id 	= purchase_file.initial_department
  		movement.sended_by 		= purchase_file.user_id
  		movement.received_by	= purchase_file.user_id
  		movement.sended_at 		= Time.now
  		movement.received_at 	= Time.now
  		movement.save
    end
end
