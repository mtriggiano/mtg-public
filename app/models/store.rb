class Store < ApplicationRecord
	include Deleteable
	include Virtus.model(mass_assignment: false, constructor: false)
  	belongs_to :company

  	has_many :external_arrivals
	has_many :external_shipments
  	has_many :users
    has_many :articles
    has_many :transfer_notes
	has_many :products, through: :articles
	
	has_many :batch_stores
    has_many :batches, through: :batch_stores

	attribute :current_user, User

  	TABLE_COLUMNS = [
  		"id" 		   => "ID",
  		"name" 		 => "Nombre",
  		"location" => "Ubicación",
  		"filled" 	 => "¿Pendiente de reposición?"
  	]

  	def external?
  		store_type == "external"
  	end
end
