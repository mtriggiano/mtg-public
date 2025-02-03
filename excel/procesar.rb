puts "***************************************"
puts "Procesar excel para la actualizacion de Stock"
require 'roo'

base = './excel/'
ext = '.xlsx'
file_paths = [
  base + 'DEPOSITO 2-VALVULAS' + ext,
  base + 'DEPOSITO 4 - DESCARTABLES-EQUIPAMIENTOS' + ext,
  base + 'DEPOSITO 4 - GUANTES' + ext,
  base + 'DEPOSITO 4 - JERINGAS' + ext
]
log_file_path = base + 'proceso.log'

log_file = File.open(log_file_path, 'a+')

data = []
file_paths.each do |file_path|
  spreadsheet = Roo::Spreadsheet.open(file_path)
  spreadsheet.each_row_streaming(offset: 2) do |row|
  data << {
    "product_id": row[0].to_s.to_i,
    "stock": row[7].to_s.to_i,
    "lote": row[10].to_s,
    "serie": row[11].to_s,
    "vencimiento": row[12].try(:value) || row[12].to_s,
    "vigente": row[13].try(:value) || row[13].to_s,
    "deposito": row[14].to_s,
  }
  end
end

# Después de tu loop que llena la variable 'data'
File.open(base + 'data.json', 'w') do |file|
  file.puts JSON.generate(data)
end


para_informar = []
editados = []
batches_creados = 0
batches_editados = 0 
ActiveRecord::Base.transaction do
  store = Store.find(3) # deposito central
  data.each do |d|
    product = Product.preload(batches: :batch_stores).where(id: d[:product_id]).first
    para_informar << d[:product_id] if product.nil?
    next if product.nil?
    
    if (d[:lote].nil? && d[:serial].nil?) || d[:lote] == "S/N"
      batch = product.batches.default_batch
    else
      batch = product.batches.select do |b|
        b.code.try(:downcase) == d[:lote].try(:downcase) && b.serial.try(:downcase) == d[:serie].try(:downcase)
      end.first
    end
    # 1. creo o edito el batch con la cantidad y fecha de vencimiento
    if batch.nil?
      batch = product.batches.create!(
        code: d[:lote],
        serial: d[:serie],
        due_date: d[:vencimiento],
        state: d[:vigente] == "SI" ? true : false,
        quantity: d[:stock]
      )
      batches_creados += 1
    else
      batch.update(quantity: d[:stock], due_date: d[:vencimiento])
      batches_editados += 1
    end
    # 2. actualizo el stock para el deposito
    batch_store = batch.batch_stores.select{|bs| bs.store_id == store.id}.first
    batch_store ||= batch.batch_stores.build(
      store: store,
      quantity: 0
    )
    batch_store.quantity = d[:stock]
    batch_store.save!

    editados << d[:product_id]
  end
end

log_file.puts "***************************************"
log_file.puts "Procesar excel para la actualizacion de Stock"
log_file.puts DateTime.now

log_file.puts "EDITADOS"
log_file.puts "Batches Creados: #{batches_creados}"
log_file.puts "Batches Editados: #{batches_editados}"
log_file.puts "#{editados.count} actualizados con exito"
log_file.puts "#{editados}"
log_file.puts "PARA INFORMAR"
log_file.puts "#{para_informar.count} no encontrados en la base de datos"


puts "editados #{editados.count}"
puts editados
