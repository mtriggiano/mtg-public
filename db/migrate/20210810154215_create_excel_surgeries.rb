class CreateExcelSurgeries < ActiveRecord::Migration[5.2]
  def change
    create_table :excel_surgeries do |t|
      t.text :paciente
      t.text :material
      t.date :fecha
      t.text :lugar
      t.text :transporte
      t.text :quirofano
      t.text :horario
      t.text :buscar_quirofano
      t.text :estado
      t.text :tipo_cx
      t.text :vendedor
      t.text :tecnico
      t.text :medico
      t.text :obs

      t.timestamps
    end
  end
end
