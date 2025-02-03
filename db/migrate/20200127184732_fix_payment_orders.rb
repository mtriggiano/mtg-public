class FixPaymentOrders < ActiveRecord::Migration[5.2]
  def change
  	drop_table :payment_order_orders
  	create_table "payment_order_bills", force: :cascade do |t|
	    t.bigint "bill_id"
	    t.bigint "payment_order_id"
	    t.float "total", default: 0.0, null: false
	    t.boolean "active", default: true, null: false
	    t.datetime "created_at", null: false
	    t.datetime "updated_at", null: false
	    t.string "number"
	    t.date "due_date"
	    t.index ["bill_id"], name: "index_payment_order_bills_on_bill_id"
	    t.index ["payment_order_id"], name: "index_payment_order_bills_on_payment_order_id"
	end
  end
end
