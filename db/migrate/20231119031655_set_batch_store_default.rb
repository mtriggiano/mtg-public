class SetBatchStoreDefault < ActiveRecord::Migration[5.2]
  def up
    deposito_central = Store.find_by(id: 1)
    
    if deposito_central
      Batch.all.each do |batch|
        BatchStore.create(
          batch: batch, 
          store: deposito_central,
          quantity: batch.quantity
        )
      end
    else
      puts "Store with id=1 not found. Skipping this migration."
    end
  end

  def down 
    # Agrega aquí el código para revertir la migración si es necesario
  end
end
