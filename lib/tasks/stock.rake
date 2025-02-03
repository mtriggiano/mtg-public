namespace :stock do

  	task build_initial: :environment do
  		company = Company.find(3)
    	store = company.stores.first
  		company.products.each do |product|
  			product.articles.where(store_id: store.id, available: product.available_stock).first_or_create
  		end
  	end

  	task purge_details: :environment do
	  	Product.all.order(created_at: :desc).each do |i|
	  		clones = Product.unscoped.where.not(id: i.id).where(name: i.name)
	  		next if clones == 0 || Product.where(id: i.id).empty?
	  		clones.each do |product_clone|
	  			BoxProduct.unscoped do
		  			product_clone.box_products.each do |pb|
		  				pb.update_columns(product_id: i.id)
		  			end
		  		end
	  			ExpedientRequestDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientArrivalDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientBillDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientBudgetDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientConsumptionDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientDevolutionDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientOrderDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)
	  			ExpedientShipmentDetail.unscoped.where(product_id: product_clone.id).update_all(product_id: i.id)

	  			BoxProduct.unscoped do
	  				product_clone.box_products.each {|bp| bp.destroy(:hard)}
	  			end
	  			Article.unscoped  do
	  				product_clone.articles.each {|a| a.destroy(:hard)}
	  			end
	  			SalePriceHistory.unscoped do
	  				product_clone.sale_price_histories.each {|a| a.destroy(:hard)}
	  			end
	  			PurchasePriceHistory.unscoped do
	  				product_clone.purchase_price_histories.each {|a| a.destroy(:hard)}
	  			end

	  			Batch.unscoped do
	  				BatchDetail.unscoped do
	  					product_clone.batches.each {|a| a.batch_details.each{|bd| bd.destroy(:hard)} && a.destroy(:hard)}
	  				end
	  			end
	  			SupplierProduct.unscoped do
	  				product_clone.supplier_products.each {|a| a.destroy(:hard)}
	  			end
	  			product_clone.destroy(:hard)
	  		end
	  	end
  	end

  	task update_batches: :environment do
  		Batch.all.each{|b| b.update_columns(code: b.code&.upcase, serial: b.serial&.upcase)}
  	end
end
