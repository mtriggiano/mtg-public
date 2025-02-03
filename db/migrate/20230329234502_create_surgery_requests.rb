class CreateSurgeryRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :surgery_requests do |t|
      t.string :number
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.date :request_date
      t.string :surgery_type
      t.date :surgery_date
      t.text :observation
      t.string :aasm_state
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.integer :age
      t.string :gender
      t.string :document_type, default: "C.U.I.T.", null: false
      t.string :document_number, null: false
      t.string :address
      t.string :mobile_phone
      t.string :phone
      t.references :province, foreign_key: true
      t.references :locality, foreign_key: true
      t.string :social_work
      t.string :pacient_number
      t.string :medical_history
      t.string :institution
      t.string :doctor
      t.boolean :internal_stock
      t.string :reason_for_rejection
      t.references :rejected_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.boolean :active, default: true, null: false
      t.string :surgery_time, null: false
      t.boolean :right_limb
      t.boolean :left_limb
      t.string :surgical_site
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :updated_by, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
