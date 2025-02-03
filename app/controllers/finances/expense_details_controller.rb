class Finances::ExpenseDetailsController < ApplicationController
	include Indexable
	skip_load_and_authorize_resource
	
	expose :expense_detail

	def edit
		
	end
end
