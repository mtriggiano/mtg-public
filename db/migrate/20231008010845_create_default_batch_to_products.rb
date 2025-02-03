class CreateDefaultBatchToProducts < ActiveRecord::Migration[5.2]
  def up
    Product.includes(:batches).all.each do |product|
      batch = product.batches.where(code: "S/N").first || product.batches.where(code: "S/N", quantity: 0).first_or_create 
      batch.default = true
      batch.save!(validate: :false)
    end
  end 

  def down 
  end
end
