class DataMethods

	def self.sales_bills_by_client(properties)
		
    		ExpedientBill.joins(:entity).group('entities.name').order('entities.name').count
    	
  	end
end