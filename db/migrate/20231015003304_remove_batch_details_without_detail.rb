class RemoveBatchDetailsWithoutDetail < ActiveRecord::Migration[5.2]
  def up
    contador = 0
    BatchDetail.select do |batch_detail|
      if batch_detail.detail.nil?
        batch_detail.destroy!
        contador += 1
      end
    end
    puts "Se eliminaron #{contador} batch_details sin detail"    
  end

  def down
  end
end
