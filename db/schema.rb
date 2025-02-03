# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_10_30_021015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.string "class_name"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_abilities_on_role_id"
  end

  create_table "ability_actions", force: :cascade do |t|
    t.string "name"
    t.bigint "ability_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_ability_actions_on_ability_id"
  end

  create_table "account_movements", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "bill_id"
    t.bigint "receipt_id"
    t.string "cbte_tipo", null: false
    t.string "flow", null: false
    t.boolean "active", default: true, null: false
    t.float "total", default: 0.0, null: false
    t.float "balance", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_order_id"
    t.date "date"
    t.index ["bill_id"], name: "index_account_movements_on_bill_id"
    t.index ["entity_id"], name: "index_account_movements_on_entity_id"
    t.index ["payment_order_id"], name: "index_account_movements_on_payment_order_id"
    t.index ["receipt_id"], name: "index_account_movements_on_receipt_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "activitable_type"
    t.bigint "activitable_id"
    t.string "photo", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.string "activity_type", null: false
    t.string "link"
    t.bigint "user_id"
    t.bigint "company_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activitable_type", "activitable_id"], name: "index_attachments_on_activitable_type_and_activitable_id"
    t.index ["company_id"], name: "index_activities_on_company_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.string "title", null: false
    t.date "init_date", default: -> { "('now'::text)::date" }, null: false
    t.date "final_date", default: -> { "('now'::text)::date" }, null: false
    t.text "body"
    t.text "observation"
    t.bigint "user_id"
    t.string "alertable_type"
    t.bigint "alertable_id"
    t.boolean "active", default: true, null: false
    t.string "state", default: "Pendiente", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["alertable_type", "alertable_id"], name: "index_attachments_on_alertable_type_and_alertable_id"
    t.index ["company_id"], name: "index_alerts_on_company_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "alerts_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alert_id", null: false
    t.index ["alert_id", "user_id"], name: "index_alerts_users_on_alert_id_and_user_id"
    t.index ["user_id", "alert_id"], name: "index_alerts_users_on_user_id_and_alert_id"
  end

  create_table "arrival_details", force: :cascade do |t|
    t.bigint "arrival_id"
    t.bigint "product_id"
    t.string "product_name", null: false
    t.float "requested_quantity", null: false
    t.float "quantity", default: 0.0, null: false
    t.boolean "cumpliment", default: true, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "arrival_detail_id"
    t.string "type"
    t.text "description"
    t.string "product_supplier_code"
    t.integer "transaction_id"
    t.hstore "custom_attributes"
    t.string "product_code"
    t.string "product_measurement", default: "Unidad", null: false
    t.string "branch"
    t.integer "number"
    t.index ["arrival_id"], name: "index_arrival_details_on_arrival_id"
    t.index ["product_id"], name: "index_arrival_details_on_product_id"
  end

  create_table "arrivals", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "user_id"
    t.bigint "store_id"
    t.boolean "active", default: true, null: false
    t.string "state", default: "Pendiente", null: false
    t.string "observation"
    t.date "date", default: -> { "('now'::text)::date" }, null: false
    t.integer "punctuation", default: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.string "number"
    t.hstore "custom_attributes"
    t.string "type"
    t.bigint "file_id"
    t.boolean "delivered_shipments"
    t.integer "shipment_id"
    t.boolean "traslado_stock_interno", default: false
    t.index ["company_id"], name: "index_arrivals_on_company_id"
    t.index ["entity_id"], name: "index_arrivals_on_entity_id"
    t.index ["file_id"], name: "index_arrivals_on_file_id"
    t.index ["store_id"], name: "index_arrivals_on_store_id"
    t.index ["user_id"], name: "index_arrivals_on_user_id"
  end

  create_table "arrivals_orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "arrival_id"
    t.boolean "active", default: true, null: false
    t.string "type"
    t.index ["arrival_id"], name: "index_arrivals_orders_on_arrival_id"
    t.index ["order_id"], name: "index_arrivals_orders_on_order_id"
  end

  create_table "arrivals_requests", force: :cascade do |t|
    t.bigint "arrival_id"
    t.bigint "request_id"
    t.string "type"
    t.boolean "active", default: true, null: false
    t.index ["arrival_id"], name: "index_arrivals_requests_on_arrival_id"
    t.index ["request_id"], name: "index_arrivals_requests_on_request_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "file", default: "/images/attachment.png", null: false
    t.string "original_filename", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.integer "state", default: 0, null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "attendance_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.float "price_per_hour"
    t.float "price_per_extra_hour"
    t.float "early"
    t.float "late"
    t.time "check_in"
    t.time "check_out"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_attendance_categories_on_company_id"
  end

  create_table "attendance_category_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "attendance_category_id"
    t.index ["attendance_category_id"], name: "index_attendance_category_users_on_attendance_category_id"
    t.index ["user_id"], name: "index_attendance_category_users_on_user_id"
  end

  create_table "attendance_resumes", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.decimal "cumpliment"
    t.bigint "user_id"
    t.float "worked_hours", default: 0.0
    t.float "extra_hours", default: 0.0
    t.date "initial_date"
    t.date "final_date"
    t.float "att_count", default: 0.0
    t.float "total_att_in_month", default: 0.0
    t.boolean "active", default: true
    t.string "label_date"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_attendance_resumes_on_company_id"
    t.index ["user_id"], name: "index_attendance_resumes_on_user_id"
  end

  create_table "attendance_settings", force: :cascade do |t|
    t.string "resume_type"
    t.integer "first_day_of_resume"
    t.integer "last_day_of_resume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "attendance_resume_id"
    t.date "date", null: false
    t.boolean "present", default: false
    t.boolean "vacation", default: false
    t.boolean "justified", default: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.float "work_time"
    t.boolean "late_alert", default: false
    t.boolean "no_category_alert", default: false
    t.float "minutes_late", default: 0.0
    t.string "present_label"
    t.string "justification_label"
    t.boolean "active", default: true
    t.string "justificable_type"
    t.bigint "justificable_id"
    t.boolean "early_alert", default: false
    t.index ["attendance_resume_id"], name: "index_attendances_on_attendance_resume_id"
    t.index ["justificable_type", "justificable_id"], name: "index_attendances_on_justificable_type_and_justificable_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bank_account_importer_configurations", force: :cascade do |t|
    t.bigint "bank_account_id"
    t.integer "fecha"
    t.integer "debito"
    t.integer "credito"
    t.integer "saldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "descripcion"
    t.boolean "amount_column_type_unique", default: false
    t.integer "amount"
    t.index ["bank_account_id"], name: "index_bank_account_importer_configurations_on_bank_account_id"
  end

  create_table "bank_account_movements", force: :cascade do |t|
    t.string "transaction_type"
    t.bigint "transaction_id"
    t.date "due_date"
    t.date "emision"
    t.integer "doc_type", null: false
    t.bigint "bank_account_id"
    t.bigint "supplier_id"
    t.integer "state", null: false
    t.string "observation"
    t.decimal "total", precision: 10, scale: 2, null: false
    t.string "payments"
    t.decimal "balance", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_bank_account_movements_on_bank_account_id"
    t.index ["supplier_id"], name: "index_bank_account_movements_on_supplier_id"
    t.index ["transaction_type", "transaction_id"], name: "polymorphic_index"
  end

  create_table "bank_account_transactions", force: :cascade do |t|
    t.date "fecha", null: false
    t.string "descripcion", null: false
    t.bigint "bank_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "credito", precision: 10, scale: 2, null: false
    t.decimal "debito", precision: 10, scale: 2, null: false
    t.decimal "saldo", precision: 10, scale: 2, null: false
    t.boolean "imported", default: false
    t.index ["bank_account_id"], name: "index_bank_account_transactions_on_bank_account_id"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "alias_tag"
    t.string "type"
    t.string "number", null: false
    t.string "cbu", null: false
    t.bigint "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "saldo_disponible", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["bank_id"], name: "index_bank_accounts_on_bank_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["company_id"], name: "index_banks_on_company_id"
  end

  create_table "batch_details", force: :cascade do |t|
    t.bigint "batch_id"
    t.string "detail_type"
    t.bigint "detail_id"
    t.float "quantity", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "returned", default: 0.0, null: false
    t.integer "state"
    t.integer "flow"
    t.bigint "store_id"
    t.index ["batch_id"], name: "index_batch_details_on_batch_id"
    t.index ["detail_type", "detail_id"], name: "index_batch_details_on_detail_type_and_detail_id"
    t.index ["store_id"], name: "index_batch_details_on_store_id"
  end

  create_table "batch_stores", force: :cascade do |t|
    t.bigint "batch_id"
    t.bigint "store_id"
    t.float "quantity", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_stores_on_batch_id"
    t.index ["store_id"], name: "index_batch_stores_on_store_id"
  end

  create_table "batches", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.bigint "arrival_detail_id"
    t.bigint "shipment_detail_id"
    t.integer "transaction_id"
    t.string "serial"
    t.boolean "state", default: true
    t.date "due_date"
    t.bigint "consumption_detail_id"
    t.bigint "devolution_detail_id"
    t.bigint "supplier_product_id"
    t.bigint "product_id"
    t.float "quantity", default: 0.0, null: false
    t.boolean "imported", default: false
    t.boolean "default", default: false
    t.index ["arrival_detail_id"], name: "index_batches_on_arrival_detail_id"
    t.index ["devolution_detail_id"], name: "index_batches_on_devolution_detail_id"
    t.index ["product_id"], name: "index_batches_on_product_id"
    t.index ["shipment_detail_id"], name: "index_batches_on_shipment_detail_id"
    t.index ["supplier_product_id"], name: "index_batches_on_supplier_product_id"
  end

  create_table "bill_arrivals", force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "arrival_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_id"], name: "index_bill_arrivals_on_arrival_id"
    t.index ["bill_id"], name: "index_bill_arrivals_on_bill_id"
  end

  create_table "bill_details", force: :cascade do |t|
    t.float "quantity", default: 0.0, null: false
    t.string "product_name", null: false
    t.string "product_measurement", null: false
    t.float "price", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "bonus_amount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.string "iva_aliquot", default: "05", null: false
    t.float "iva_amount", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.bigint "bill_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_supplier_code"
    t.decimal "neto", default: "0.0", null: false
    t.string "type"
    t.string "product_code"
    t.string "subtype"
    t.bigint "seller_id"
    t.string "branch"
    t.integer "number"
    t.index ["bill_id"], name: "index_bill_details_on_bill_id"
    t.index ["product_id"], name: "index_bill_details_on_product_id"
  end

  create_table "bill_movements", force: :cascade do |t|
    t.bigint "bill_id"
    t.date "date", default: -> { "CURRENT_DATE" }, null: false
    t.string "bill_name", null: false
    t.string "client", null: false
    t.string "delivered_to"
    t.boolean "signed", default: false, null: false
    t.boolean "returned", default: false, null: false
    t.text "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_movements_on_bill_id"
  end

  create_table "bill_optionals", force: :cascade do |t|
    t.bigint "bill_id"
    t.integer "afip_id"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_optionals_on_bill_id"
  end

  create_table "bill_shipments", force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "shipment_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_shipments_on_bill_id"
    t.index ["shipment_id"], name: "index_bill_shipments_on_shipment_id"
  end

  create_table "bills", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "state", default: "Pendiente", null: false
    t.float "total", default: 0.0, null: false
    t.float "total_pay", default: 0.0, null: false
    t.float "total_left", default: 0.0, null: false
    t.string "sale_point"
    t.string "header_result"
    t.string "authorized_on"
    t.string "cae_due_date"
    t.string "cae"
    t.string "cbte_tipo", null: false
    t.string "concept", null: false
    t.string "cbte_fch"
    t.float "imp_tot_conc", default: 0.0, null: false
    t.float "imp_op_ex", default: 0.0, null: false
    t.float "imp_trib", default: 0.0, null: false
    t.float "imp_neto", default: 0.0, null: false
    t.float "imp_iva", default: 0.0, null: false
    t.integer "cbte_desde"
    t.integer "cbte_hasta"
    t.string "iva_cond", null: false
    t.string "number"
    t.bigint "parent_bill"
    t.date "fch_ser_desde"
    t.date "fech_ser_hasta"
    t.date "fch_vto_pago"
    t.text "observation"
    t.boolean "expired", default: false, null: false
    t.bigint "entity_id"
    t.bigint "company_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "custom_attributes"
    t.bigint "surgery_file_id"
    t.datetime "reception_date"
    t.string "receptor_name"
    t.integer "estimated_days_to_pay"
    t.string "type"
    t.bigint "file_id"
    t.string "flow", null: false
    t.float "gross_amount", default: 0.0
    t.float "iva_amount", default: 0.0
    t.date "due_date"
    t.float "total_trib", default: 0.0, null: false
    t.date "registration_date"
    t.decimal "total_usd", precision: 10, scale: 2, default: "0.0"
    t.decimal "usd_price", precision: 10, scale: 2, default: "0.0"
    t.string "currency", default: "ARS"
    t.string "manual", default: "E", null: false
    t.text "afip_error"
    t.bigint "payment_type_id"
    t.date "date"
    t.string "document_type"
    t.string "document_number"
    t.boolean "canceled", default: false, null: false
    t.text "note"
    t.integer "due_days"
    t.index ["company_id"], name: "index_bills_on_company_id"
    t.index ["entity_id"], name: "index_bills_on_entity_id"
    t.index ["file_id"], name: "index_bills_on_file_id"
    t.index ["payment_type_id"], name: "index_bills_on_payment_type_id"
    t.index ["type"], name: "index_bills_on_type"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "bills_orders", force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "order_id"
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.index ["bill_id"], name: "index_bills_orders_on_bill_id"
    t.index ["order_id"], name: "index_bills_orders_on_order_id"
  end

  create_table "box_products", force: :cascade do |t|
    t.bigint "product_id"
    t.float "quantity"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "box_id", null: false
    t.index ["product_id"], name: "index_box_products_on_product_id"
  end

  create_table "budget_attachments", force: :cascade do |t|
    t.string "file", default: "/images/attachment.png", null: false
    t.string "original_filename"
    t.boolean "active", default: true
    t.bigint "file_id"
    t.bigint "entity_id"
    t.string "entity_name"
    t.string "detail"
    t.string "objeto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "budget_details", force: :cascade do |t|
    t.bigint "budget_id"
    t.boolean "active", default: true, null: false
    t.bigint "product_id"
    t.string "product_name", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_supplier_code"
    t.string "product_measurement"
    t.string "type", null: false
    t.bigint "budget_detail_id"
    t.string "iva_aliquot", default: "05", null: false
    t.string "product_code"
    t.text "description"
    t.hstore "custom_attributes"
    t.boolean "base_offer", default: false, null: false
    t.float "iva_amount", default: 0.0, null: false
    t.string "branch"
    t.string "source"
    t.string "detail_type"
    t.integer "number"
    t.index ["budget_id"], name: "index_budget_details_on_budget_id"
    t.index ["product_id"], name: "index_budget_details_on_product_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.string "number", null: false
    t.date "init_date", default: -> { "('now'::text)::date" }, null: false
    t.date "final_date", default: -> { "('now'::text)::date" }, null: false
    t.string "state", default: "Pendiente", null: false
    t.float "subtotal", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.date "delivery_date"
    t.string "delivery_address"
    t.text "observation"
    t.bigint "company_id"
    t.bigint "user_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_contact_id"
    t.hstore "custom_attributes"
    t.bigint "surgery_file_id"
    t.string "type"
    t.bigint "file_id"
    t.decimal "usd_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_usd", precision: 10, scale: 2, default: "0.0"
    t.bigint "seller_id"
    t.string "currency", default: "ARS"
    t.string "budget_state", default: "Pendiente"
    t.string "payment_type"
    t.index ["company_id"], name: "index_budgets_on_company_id"
    t.index ["entity_contact_id"], name: "index_budgets_on_entity_contact_id"
    t.index ["entity_id"], name: "index_budgets_on_entity_id"
    t.index ["file_id"], name: "index_budgets_on_file_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "budgets_requests", force: :cascade do |t|
    t.string "active", default: "t", null: false
    t.bigint "budget_id"
    t.bigint "request_id"
    t.string "type", null: false
    t.index ["budget_id"], name: "index_budgets_requests_on_budget_id"
    t.index ["request_id"], name: "index_budgets_requests_on_request_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name", null: false
    t.string "card_type", null: false
    t.integer "one_payment_delay", null: false
    t.integer "installments_delay", null: false
    t.string "delay_type", null: false
    t.bigint "bank_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["bank_id"], name: "index_cards_on_bank_id"
    t.index ["company_id"], name: "index_cards_on_company_id"
  end

  create_table "cash_account_logs", force: :cascade do |t|
    t.bigint "cash_account_id"
    t.date "date", null: false
    t.string "description", null: false
    t.boolean "flow", null: false
    t.decimal "monto", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "forma"
    t.string "logable_type"
    t.bigint "logable_id"
    t.string "codigo"
    t.string "entidad"
    t.index ["cash_account_id"], name: "index_cash_account_logs_on_cash_account_id"
    t.index ["logable_type", "logable_id"], name: "index_cash_account_logs_on_logable_type_and_logable_id"
    t.index ["user_id"], name: "index_cash_account_logs_on_user_id"
  end

  create_table "cash_accounts", force: :cascade do |t|
    t.string "nombre", null: false
    t.decimal "saldo", precision: 10, scale: 2, default: "0.0", null: false
    t.string "type", null: false
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_cash_accounts_on_company_id"
    t.index ["user_id"], name: "index_cash_accounts_on_user_id"
  end

  create_table "cash_refunds", force: :cascade do |t|
    t.bigint "cash_solicitude_id"
    t.bigint "user_id"
    t.date "fecha", null: false
    t.decimal "importe", precision: 10, scale: 2, null: false
    t.text "observacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_solicitude_id"], name: "index_cash_refunds_on_cash_solicitude_id"
    t.index ["user_id"], name: "index_cash_refunds_on_user_id"
  end

  create_table "cash_solicitudes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "motivo", null: false
    t.date "fecha", null: false
    t.boolean "active", default: true, null: false
    t.boolean "evaluacion"
    t.bigint "evaluador_id"
    t.string "rechazo"
    t.boolean "fecha_eval"
    t.decimal "monto_aprobado", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo"
    t.string "estado"
    t.text "descripcion"
    t.string "nombre_solicitante"
    t.index ["company_id"], name: "index_cash_solicitudes_on_company_id"
    t.index ["evaluador_id"], name: "index_cash_solicitudes_on_evaluador_id"
    t.index ["user_id"], name: "index_cash_solicitudes_on_user_id"
  end

  create_table "cash_withdrawals", force: :cascade do |t|
    t.bigint "cash_solicitude_id"
    t.bigint "user_id"
    t.decimal "importe", precision: 10, scale: 2, null: false
    t.date "fecha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_solicitude_id"], name: "index_cash_withdrawals_on_cash_solicitude_id"
    t.index ["user_id"], name: "index_cash_withdrawals_on_user_id"
  end

  create_table "check_amends", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "emitted_check_id"
    t.index ["emitted_check_id"], name: "index_check_amends_on_emitted_check_id"
  end

  create_table "checkbooks", force: :cascade do |t|
    t.string "number"
    t.string "init_number"
    t.string "final_number"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bank_account_id"
    t.string "serie"
    t.decimal "monto_acumulado", precision: 10, scale: 2
    t.index ["bank_account_id"], name: "index_checkbooks_on_bank_account_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "articleable_type"
    t.bigint "articleable_id"
    t.bigint "user_id"
    t.string "body", limit: 10000, null: false
    t.boolean "seen", default: false, null: false
    t.datetime "seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["articleable_type", "articleable_id"], name: "index_comments_on_articleable_type_and_articleable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "society_name", null: false
    t.string "code", null: false
    t.string "email", null: false
    t.string "logo", default: "/images/default_logo.png", null: false
    t.string "address"
    t.string "cuit"
    t.string "concept", null: false
    t.string "currency", default: "PES", null: false
    t.string "iva_cond", default: "Responsable Monotributo", null: false
    t.string "postal_code"
    t.date "activity_init_date"
    t.string "contact_number"
    t.string "environment", default: "test", null: false
    t.string "cbu"
    t.boolean "paid", default: false, null: false
    t.string "suscription_type"
    t.bigint "locality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.float "coefficient_for_net_amount", default: 0.74
    t.string "anmat_user"
    t.string "anmat_password"
    t.string "gln"
    t.string "anmat_type"
    t.string "pdf_logo"
    t.string "gross_income"
    t.index ["locality_id"], name: "index_companies_on_locality_id"
  end

  create_table "consumptions_shipments", force: :cascade do |t|
    t.bigint "shipment_id"
    t.bigint "consumption_id"
    t.boolean "active", default: true, null: false
    t.string "type", null: false
    t.index ["shipment_id"], name: "index_consumptions_shipments_on_shipment_id"
  end

  create_table "cost_categories", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cost_sub_categories", force: :cascade do |t|
    t.string "nombre", null: false
    t.bigint "cost_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cost_category_id"], name: "index_cost_sub_categories_on_cost_category_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "cx_notifications", force: :cascade do |t|
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fileable_type"
    t.bigint "fileable_id"
    t.index ["fileable_type", "fileable_id"], name: "index_cx_notifications_on_fileable_type_and_fileable_id"
  end

  create_table "daily_cash_balances", force: :cascade do |t|
    t.bigint "cash_account_id"
    t.boolean "apertura", null: false
    t.decimal "importe", precision: 10, scale: 2, null: false
    t.date "fecha", null: false
    t.bigint "user_id"
    t.string "type"
    t.decimal "balance", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "cuenta_monedas"
    t.index ["cash_account_id"], name: "index_daily_cash_balances_on_cash_account_id"
    t.index ["user_id"], name: "index_daily_cash_balances_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.string "for_model"
    t.bigint "object_id"
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["company_id"], name: "index_departments_on_company_id"
    t.index ["user_id"], name: "index_departments_on_user_id"
  end

  create_table "devolution_arrivals", force: :cascade do |t|
    t.bigint "devolution_id"
    t.bigint "arrival_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_id"], name: "index_devolution_arrivals_on_arrival_id"
    t.index ["devolution_id"], name: "index_devolution_arrivals_on_devolution_id"
  end

  create_table "devolution_consumptions", force: :cascade do |t|
    t.bigint "devolution_id"
    t.bigint "consumption_id"
    t.string "type"
    t.boolean "active"
    t.index ["devolution_id"], name: "index_devolution_consumptions_on_devolution_id"
  end

  create_table "devolution_details", force: :cascade do |t|
    t.bigint "devolution_id"
    t.bigint "product_id"
    t.float "quantity", default: 0.0, null: false
    t.string "return_reason", null: false
    t.string "product_name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "devolution_detail_id"
    t.string "product_measurement", default: "unidades", null: false
    t.bigint "batch_id"
    t.string "type"
    t.integer "number"
    t.index ["batch_id"], name: "index_devolution_details_on_batch_id"
    t.index ["devolution_id"], name: "index_devolution_details_on_devolution_id"
    t.index ["product_id"], name: "index_devolution_details_on_product_id"
  end

  create_table "devolution_shipments", force: :cascade do |t|
    t.bigint "devolution_id"
    t.bigint "shipment_id"
    t.string "type"
    t.boolean "active"
    t.index ["devolution_id"], name: "index_devolution_shipments_on_devolution_id"
    t.index ["shipment_id"], name: "index_devolution_shipments_on_shipment_id"
  end

  create_table "devolutions", force: :cascade do |t|
    t.bigint "file_id"
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "entity_id"
    t.string "number", null: false
    t.boolean "active", default: true, null: false
    t.text "observation"
    t.date "date", default: -> { "('now'::text)::date" }, null: false
    t.string "state", default: "Pendiente", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "custom_attributes"
    t.float "shipping_price", default: 0.0, null: false
    t.string "type"
    t.bigint "store_id"
    t.string "shipment_number"
    t.index ["company_id"], name: "index_devolutions_on_company_id"
    t.index ["entity_id"], name: "index_devolutions_on_entity_id"
    t.index ["file_id"], name: "index_devolutions_on_file_id"
    t.index ["store_id"], name: "index_devolutions_on_store_id"
    t.index ["user_id"], name: "index_devolutions_on_user_id"
  end

  create_table "devolutions_arrivals", force: :cascade do |t|
    t.bigint "devolution_id"
    t.bigint "arrival_id"
    t.boolean "active", default: true, null: false
    t.string "type"
    t.index ["arrival_id"], name: "index_devolutions_arrivals_on_arrival_id"
    t.index ["devolution_id"], name: "index_devolutions_arrivals_on_devolution_id"
  end

  create_table "dolar_cotizations", force: :cascade do |t|
    t.date "date"
    t.string "dolar_type"
    t.float "dolar_buy"
    t.float "dolar_sell"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emitted_checks", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "company_id"
    t.bigint "payment_order_id"
    t.string "concepto", null: false
    t.decimal "importe", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "importe_pagado", precision: 10, scale: 2, null: false
    t.decimal "saldo", precision: 10, scale: 2, null: false
    t.bigint "checkbook_id"
    t.string "numero", null: false
    t.date "vencimiento", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado"
    t.bigint "bank_account_id"
    t.string "check_type", default: "Cheque"
    t.index ["checkbook_id"], name: "index_emitted_checks_on_checkbook_id"
    t.index ["company_id"], name: "index_emitted_checks_on_company_id"
    t.index ["entity_id"], name: "index_emitted_checks_on_entity_id"
    t.index ["payment_order_id"], name: "index_emitted_checks_on_payment_order_id"
  end

  create_table "entities", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "address"
    t.string "document_type", default: "C.U.I.T.", null: false
    t.string "document_number", null: false
    t.boolean "active", default: true, null: false
    t.string "iva_cond", default: "Responsable Inscripto", null: false
    t.float "recharge", default: 0.0, null: false
    t.float "current_balance", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gln"
    t.string "type", null: false
    t.string "bank"
    t.string "account"
    t.string "cbu"
    t.string "subtype"
    t.string "sector"
    t.string "denomination"
    t.bigint "payment_type_id"
    t.integer "payment_days"
    t.bigint "province_id"
    t.bigint "locality_id"
    t.string "cp"
    t.bigint "parent_id"
    t.boolean "iibb_perception"
    t.decimal "iibb_aliquot", precision: 10, scale: 2, default: "3.6"
    t.string "id_medtronic"
    t.index ["company_id"], name: "index_entities_on_company_id"
    t.index ["locality_id"], name: "index_entities_on_locality_id"
    t.index ["payment_type_id"], name: "index_entities_on_payment_type_id"
    t.index ["province_id"], name: "index_entities_on_province_id"
  end

  create_table "entity_banks", force: :cascade do |t|
    t.bigint "entity_id"
    t.string "cbu", limit: 22, null: false
    t.string "alias", limit: 200, null: false
    t.string "cuit", limit: 22, null: false
    t.string "name", limit: 200, null: false
    t.string "account_type", limit: 200, null: false
    t.string "branch_office", limit: 200
    t.string "denomination", limit: 200
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_entity_banks_on_entity_id"
  end

  create_table "entity_contacts", force: :cascade do |t|
    t.bigint "entity_id"
    t.boolean "active"
    t.boolean "titular"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "mobile_phone"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_entity_contacts_on_entity_id"
  end

  create_table "entity_records", force: :cascade do |t|
    t.bigint "entity_contact_id"
    t.bigint "user_id"
    t.date "date", default: -> { "('now'::text)::date" }, null: false
    t.string "title", null: false
    t.string "object", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.bigint "client_contact_id"
    t.index ["client_contact_id"], name: "index_entity_records_on_client_contact_id"
    t.index ["entity_contact_id"], name: "index_entity_records_on_entity_contact_id"
    t.index ["user_id"], name: "index_entity_records_on_user_id"
  end

  create_table "excel_surgeries", force: :cascade do |t|
    t.text "paciente"
    t.text "material"
    t.date "fecha"
    t.text "lugar"
    t.text "transporte"
    t.text "quirofano"
    t.text "horario"
    t.text "buscar_quirofano"
    t.text "estado"
    t.text "tipo_cx"
    t.text "vendedor"
    t.text "tecnico"
    t.text "medico"
    t.text "obs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditures", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "company_id"
    t.string "supplier_name", null: false
    t.string "tipo", null: false
    t.string "punto_venta"
    t.string "numero"
    t.string "descripcion", null: false
    t.decimal "importe_bruto", precision: 10, scale: 2, null: false
    t.decimal "importe_neto", precision: 10, scale: 2, null: false
    t.decimal "iva", precision: 10, scale: 2, null: false
    t.decimal "iibb", precision: 10, scale: 2, null: false
    t.decimal "no_gravado", precision: 10, scale: 2, null: false
    t.date "fecha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_expenditures_on_company_id"
    t.index ["entity_id"], name: "index_expenditures_on_entity_id"
  end

  create_table "expense_details", force: :cascade do |t|
    t.bigint "cash_solicitude_id"
    t.date "fecha", null: false
    t.string "letra", null: false
    t.string "punto_venta", null: false
    t.string "num_comprobante", null: false
    t.bigint "entity_id"
    t.string "supplier_name", null: false
    t.string "descripcion", null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.decimal "sum_iva", precision: 10, scale: 2
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "no_gravados", precision: 10, scale: 2
    t.decimal "percep_iibb", precision: 10, scale: 2
    t.bigint "order_id"
    t.bigint "company_id"
    t.bigint "cash_account_id"
    t.string "type"
    t.integer "numero_de_recibo"
    t.string "recibe"
    t.string "representa"
    t.datetime "disabled_time"
    t.bigint "disable_user_id"
    t.float "exento", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.string "cbte_tipo", default: "01"
    t.date "fecha_registro"
    t.decimal "percep_iva"
    t.boolean "archived", default: false
    t.date "fecha_pago"
    t.string "tipo_pago"
    t.index ["cash_account_id"], name: "index_expense_details_on_cash_account_id"
    t.index ["cash_solicitude_id"], name: "index_expense_details_on_cash_solicitude_id"
    t.index ["company_id"], name: "index_expense_details_on_company_id"
    t.index ["entity_id"], name: "index_expense_details_on_entity_id"
    t.index ["order_id"], name: "index_expense_details_on_order_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "codigo"
    t.string "descripcion", null: false
    t.bigint "user_id"
    t.bigint "company_id"
    t.decimal "importe", precision: 10, scale: 2, null: false
    t.string "lugar"
    t.date "fecha", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_account_id"
    t.string "forma"
    t.string "spendable_type"
    t.bigint "spendable_id"
    t.index ["cash_account_id"], name: "index_expenses_on_cash_account_id"
    t.index ["company_id"], name: "index_expenses_on_company_id"
    t.index ["spendable_type", "spendable_id"], name: "index_expenses_on_spendable_type_and_spendable_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "file_attributes_configs", force: :cascade do |t|
    t.string "parent_model", null: false
    t.string "extra_attribute", null: false
    t.integer "quantity", default: 1, null: false
    t.bigint "company_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_file_attributes_configs_on_company_id"
  end

  create_table "file_movements", force: :cascade do |t|
    t.string "file_type", null: false
    t.bigint "file_id", null: false
    t.bigint "department_id"
    t.bigint "sended_by", null: false
    t.bigint "received_by"
    t.datetime "sended_at", null: false
    t.datetime "received_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_purchase_file_movements_on_department_id"
  end

  create_table "file_responsables", force: :cascade do |t|
    t.string "document_type", null: false
    t.bigint "user_id"
    t.text "observation"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "surgery_file_id"
    t.bigint "file_id"
    t.index ["file_id"], name: "index_file_responsables_on_file_id"
    t.index ["user_id"], name: "index_file_responsables_on_user_id"
  end

  create_table "files", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "user_id"
    t.bigint "entity_id"
    t.string "number", null: false
    t.string "title", null: false
    t.string "sale_type", default: "Venta regular", null: false
    t.date "init_date", null: false
    t.boolean "open", default: true, null: false
    t.string "state", default: "En espera de solicitud", null: false
    t.boolean "active", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "finish_date"
    t.bigint "initial_department"
    t.string "iva_aliquot", default: "05", null: false
    t.hstore "custom_attributes"
    t.string "type"
    t.date "surgery_end_date"
    t.string "substate"
    t.boolean "need_surgical_sheet", default: false, null: false
    t.boolean "need_implant", default: false, null: false
    t.boolean "need_note", default: false, null: false
    t.boolean "need_sticker", default: false, null: false
    t.integer "surgical_sheet_state", default: 0, null: false
    t.integer "implant_state", default: 0, null: false
    t.date "delivery_date"
    t.time "delivery_hour"
    t.string "technical"
    t.integer "surgical_sheet_state_2", default: 0, null: false
    t.boolean "need_surgical_sheet_2", default: false, null: false
    t.index ["company_id"], name: "index_files_on_company_id"
    t.index ["entity_id"], name: "index_files_on_entity_id"
    t.index ["user_id"], name: "index_files_on_user_id"
  end

  create_table "hidden_attributes", force: :cascade do |t|
    t.bigint "user_table_config_id"
    t.string "col"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_table_config_id"], name: "index_hidden_attributes_on_user_table_config_id"
  end

  create_table "imprest_clearings", force: :cascade do |t|
    t.bigint "general_cash_account_id"
    t.bigint "regular_cash_account_id"
    t.bigint "user_id"
    t.datetime "fecha", null: false
    t.decimal "fondo_fijo", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "saldo_inicio", precision: 10, scale: 2, default: "0.0", null: false
    t.text "observaciones"
    t.decimal "a_rendir", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "saldo_en_caja", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "tiempo_de_confirmacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "cuenta_monedas_a_rendir"
    t.json "cuenta_monedas_saldo_en_caja"
    t.index ["general_cash_account_id"], name: "index_imprest_clearings_on_general_cash_account_id"
    t.index ["regular_cash_account_id"], name: "index_imprest_clearings_on_regular_cash_account_id"
    t.index ["user_id"], name: "index_imprest_clearings_on_user_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.string "codigo"
    t.string "descripcion", null: false
    t.decimal "importe", precision: 10, scale: 2, null: false
    t.date "fecha", null: false
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "lugar"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_account_id"
    t.string "forma"
    t.string "spendable_type"
    t.bigint "spendable_id"
    t.index ["cash_account_id"], name: "index_incomes_on_cash_account_id"
    t.index ["company_id"], name: "index_incomes_on_company_id"
    t.index ["spendable_type", "spendable_id"], name: "index_incomes_on_spendable_type_and_spendable_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "justifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "creator_id"
    t.bigint "approver_id"
    t.date "init_date"
    t.date "final_date"
    t.integer "days"
    t.boolean "approved"
    t.boolean "active"
    t.bigint "company_id"
    t.string "reason"
    t.string "type"
    t.text "observation"
    t.string "reject_reason"
    t.string "principal_attachment", default: "/images/attachment.png"
    t.index ["company_id"], name: "index_justifications_on_company_id"
    t.index ["user_id"], name: "index_justifications_on_user_id"
  end

  create_table "localities", force: :cascade do |t|
    t.bigint "province_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["province_id"], name: "index_localities_on_province_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "shipment_id"
    t.string "map"
    t.string "address"
    t.string "contact"
    t.string "phone"
    t.string "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipment_id"], name: "index_locations_on_shipment_id"
  end

  create_table "non_present_users", force: :cascade do |t|
    t.bigint "attendance_id"
    t.bigint "user_id"
    t.date "date"
    t.index ["attendance_id"], name: "index_non_present_users_on_attendance_id"
    t.index ["user_id"], name: "index_non_present_users_on_user_id"
  end

  create_table "non_working_day_details", force: :cascade do |t|
    t.bigint "non_working_day_id"
    t.bigint "user_id"
    t.index ["non_working_day_id"], name: "index_non_working_day_details_on_non_working_day_id"
    t.index ["user_id"], name: "index_non_working_day_details_on_user_id"
  end

  create_table "non_working_days", force: :cascade do |t|
    t.date "date"
    t.string "reason"
    t.string "holiday_type"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_non_working_days_on_company_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "department_id"
    t.bigint "user_id"
    t.string "parent", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.string "date", default: -> { "('now'::text)::date" }, null: false
    t.boolean "seen", default: false, null: false
    t.boolean "active", default: true, null: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["company_id"], name: "index_notifications_on_company_id"
    t.index ["department_id"], name: "index_notifications_on_department_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "product_name", null: false
    t.string "product_code"
    t.float "quantity", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_measurement", default: "Unidad", null: false
    t.string "detail_type", default: "Consumo", null: false
    t.string "iva_aliquot", default: "05", null: false
    t.boolean "delivered", default: false, null: false
    t.boolean "has_stock"
    t.boolean "billed", default: false, null: false
    t.text "description"
    t.bigint "user_id"
    t.hstore "custom_attributes"
    t.boolean "custom_detail", default: false, null: false
    t.bigint "order_detail_id"
    t.bigint "order_id"
    t.string "product_supplier_code"
    t.boolean "base_offer", default: false, null: false
    t.string "tipo"
    t.string "branch"
    t.string "source"
    t.integer "number"
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
    t.index ["user_id"], name: "index_order_details_on_user_id"
  end

  create_table "order_payment_days", force: :cascade do |t|
    t.boolean "active"
    t.string "payable_type"
    t.bigint "payable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_type_id"
    t.string "observation"
    t.index ["payable_id", "payable_type"], name: "index_order_payment_days_on_payable_id_and_payable_type"
    t.index ["payable_type", "payable_id"], name: "index_order_payment_days_on_payable_type_and_payable_id"
    t.index ["payment_type_id"], name: "index_order_payment_days_on_payment_type_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "number", null: false
    t.string "state", default: "Pendiente", null: false
    t.boolean "active", default: true, null: false
    t.text "observation"
    t.float "subtotal", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.boolean "paid", default: false, null: false
    t.float "total_pay", default: 0.0, null: false
    t.float "total_left", default: 0.0, null: false
    t.boolean "delivered", default: false, null: false
    t.date "expected_delivery_date", default: -> { "('now'::text)::date" }, null: false
    t.bigint "approved_by"
    t.string "order_type", default: "Venta regular", null: false
    t.bigint "company_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.hstore "custom_attributes"
    t.bigint "surgery_file_id"
    t.string "type"
    t.bigint "file_id"
    t.bigint "store_id"
    t.float "shipping_price", default: 0.0
    t.boolean "shipping_included", default: false
    t.decimal "total_usd", precision: 10, scale: 2, default: "0.0"
    t.decimal "usd_price", precision: 10, scale: 2, default: "0.0"
    t.string "oc_number_from_os"
    t.string "currency", default: "ARS"
    t.text "document_observation"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["entity_id"], name: "index_orders_on_entity_id"
    t.index ["file_id"], name: "index_orders_on_file_id"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "orders_budgets", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "budget_id"
    t.bigint "order_id"
    t.string "type", null: false
    t.index ["budget_id"], name: "index_orders_budgets_on_budget_id"
    t.index ["order_id"], name: "index_orders_budgets_on_order_id"
  end

  create_table "orders_requests", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "order_id", null: false
    t.string "type", null: false
    t.index ["order_id", "request_id"], name: "index_orders_requests_on_order_id_and_request_id"
    t.index ["request_id", "order_id"], name: "index_orders_requests_on_request_id_and_order_id"
  end

  create_table "orders_shipments", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "shipment_id"
    t.boolean "active", default: true, null: false
    t.string "type", null: false
    t.index ["order_id"], name: "index_orders_shipments_on_order_id"
    t.index ["shipment_id"], name: "index_orders_shipments_on_shipment_id"
  end

  create_table "payment_order_bills", force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "payment_order_id"
    t.float "total", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.date "due_date"
    t.string "payment_type"
    t.float "total_left", default: 0.0, null: false
    t.bigint "payment_type_id"
    t.bigint "checkbook_id"
    t.decimal "previous_total_left", precision: 10, scale: 2
    t.decimal "previous_debt", precision: 10, scale: 2
    t.index ["bill_id"], name: "index_payment_order_bills_on_bill_id"
    t.index ["checkbook_id"], name: "index_payment_order_bills_on_checkbook_id"
    t.index ["payment_order_id"], name: "index_payment_order_bills_on_payment_order_id"
    t.index ["payment_type_id"], name: "index_payment_order_bills_on_payment_type_id"
  end

  create_table "payment_order_payments", force: :cascade do |t|
    t.bigint "payment_order_id"
    t.bigint "payment_type_id"
    t.bigint "checkbook_id"
    t.date "due_date"
    t.string "number"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bank_account_id"
    t.index ["bank_account_id"], name: "index_payment_order_payments_on_bank_account_id"
    t.index ["checkbook_id"], name: "index_payment_order_payments_on_checkbook_id"
    t.index ["payment_order_id"], name: "index_payment_order_payments_on_payment_order_id"
    t.index ["payment_type_id"], name: "index_payment_order_payments_on_payment_type_id"
  end

  create_table "payment_orders", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "order_payment_day_id"
    t.string "state", default: "Pendiente", null: false
    t.bigint "user_id"
    t.boolean "active", default: true, null: false
    t.date "date", null: false
    t.float "total", null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "file_id"
    t.bigint "company_id"
    t.text "concept"
    t.hstore "custom_attributes"
    t.string "currency", default: "ARS"
    t.text "observations"
    t.boolean "imported", default: false
    t.index ["company_id"], name: "index_payment_orders_on_company_id"
    t.index ["entity_id"], name: "index_payment_orders_on_entity_id"
    t.index ["file_id"], name: "index_payment_orders_on_file_id"
    t.index ["order_id"], name: "index_payment_orders_on_order_id"
    t.index ["order_payment_day_id"], name: "index_payment_orders_on_order_payment_day_id"
    t.index ["user_id"], name: "index_payment_orders_on_user_id"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "imputed_in_cash", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "cash_account_id"
    t.string "collect_type"
    t.float "balance", default: 0.0, null: false
    t.index ["cash_account_id"], name: "index_payment_types_on_cash_account_id"
    t.index ["company_id"], name: "index_payment_types_on_company_id"
  end

  create_table "price_histories", force: :cascade do |t|
    t.bigint "product_id"
    t.string "currency", default: "ARS", null: false
    t.float "price", default: 0.0, null: false
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_price_histories_on_entity_id"
    t.index ["product_id"], name: "index_price_histories_on_product_id"
  end

  create_table "price_updates", force: :cascade do |t|
    t.decimal "percent"
    t.bigint "created_by_id"
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_price_updates_on_company_id"
    t.index ["created_by_id"], name: "index_price_updates_on_created_by_id"
    t.index ["user_id"], name: "index_price_updates_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "default_iva", default: "05", null: false
    t.boolean "active", default: true, null: false
    t.integer "products_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "boxes_count", default: 0, null: false
    t.index ["company_id"], name: "index_product_categories_on_company_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.bigint "product_id"
    t.string "source", default: "/images/default_product.png", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "product_category_id"
    t.string "name", null: false
    t.string "code", null: false
    t.boolean "active", default: true, null: false
    t.string "measurement", default: "1", null: false
    t.string "measurement_unit", default: "7", null: false
    t.string "clasification", default: "Producto", null: false
    t.float "minimum_stock", default: 0.0, null: false
    t.float "available_stock", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_type", default: "regular", null: false
    t.boolean "traceable", default: true, null: false
    t.string "type", null: false
    t.string "gtin"
    t.string "pm"
    t.string "family"
    t.float "recommended_stock", default: 0.0, null: false
    t.string "branch"
    t.string "source"
    t.boolean "own", default: true, null: false
    t.boolean "selectable", default: true
    t.bigint "supplier_id"
    t.decimal "buy_price", precision: 10, scale: 2, default: "0.0"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "promissory_payments", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "company_id"
    t.bigint "receipt_id"
    t.string "concepto", null: false
    t.decimal "importe", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "importe_cobrado", precision: 10, scale: 2
    t.string "numero_cheque"
    t.date "vencimiento", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_deposito"
    t.bigint "old_bank_check_id"
    t.bigint "bank_account_id"
    t.index ["bank_account_id"], name: "index_promissory_payments_on_bank_account_id"
    t.index ["company_id"], name: "index_promissory_payments_on_company_id"
    t.index ["entity_id"], name: "index_promissory_payments_on_entity_id"
    t.index ["receipt_id"], name: "index_promissory_payments_on_receipt_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["country_id"], name: "index_provinces_on_country_id"
  end

  create_table "purchase_request_supplier_requests", force: :cascade do |t|
    t.bigint "purchase_request_id"
    t.bigint "supplier_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_request_id", "supplier_request_id"], name: "request_request_index", unique: true
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "file_id"
    t.bigint "company_id"
    t.bigint "user_id"
    t.boolean "active", default: true, null: false
    t.float "total", default: 0.0, null: false
    t.date "date", null: false
    t.text "concept"
    t.string "number", null: false
    t.string "state", default: "Pendiente", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "custom_attributes"
    t.string "client_payment_order"
    t.string "currency", default: "ARS"
    t.text "observation"
    t.string "receipt_type", default: "normal"
    t.index ["company_id"], name: "index_receipts_on_company_id"
    t.index ["entity_id"], name: "index_receipts_on_entity_id"
    t.index ["file_id"], name: "index_receipts_on_file_id"
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "receipts_bills", force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "receipt_id"
    t.float "total", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.float "total_left", default: 0.0, null: false
    t.datetime "updated_at"
    t.decimal "available_to_assign", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["bill_id"], name: "index_receipts_bills_on_bill_id"
    t.index ["receipt_id"], name: "index_receipts_bills_on_receipt_id"
  end

  create_table "receipts_payments", force: :cascade do |t|
    t.bigint "receipt_id"
    t.decimal "total", precision: 10, scale: 2, null: false
    t.string "number"
    t.date "due_date"
    t.bigint "payment_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bank_account_id"
    t.date "real_date"
    t.index ["bank_account_id"], name: "index_receipts_payments_on_bank_account_id"
    t.index ["payment_type_id"], name: "index_receipts_payments_on_payment_type_id"
    t.index ["receipt_id"], name: "index_receipts_payments_on_receipt_id"
  end

  create_table "request_details", force: :cascade do |t|
    t.bigint "product_id"
    t.string "product_name", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "approved_quantity", default: 0.0, null: false
    t.string "description"
    t.string "state", default: "Pendiente", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_code"
    t.string "detail_type", default: "Consumo", null: false
    t.bigint "request_detail_id"
    t.bigint "request_id"
    t.hstore "custom_attributes"
    t.string "product_supplier_code"
    t.boolean "base_offer", default: false, null: false
    t.string "product_measurement", default: "Unidad", null: false
    t.string "type"
    t.string "branch"
    t.integer "number"
    t.index ["product_id"], name: "index_request_details_on_product_id"
    t.index ["request_id"], name: "index_request_details_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "number", null: false
    t.date "init_date", default: -> { "('now'::text)::date" }, null: false
    t.date "final_date", default: -> { "('now'::text)::date" }, null: false
    t.integer "urgency", default: 1, null: false
    t.string "request_type", default: "Venta regular", null: false
    t.text "observation"
    t.string "state", default: "Pendiente", null: false
    t.boolean "active", default: true, null: false
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "custom_attributes"
    t.bigint "surgery_file_id"
    t.boolean "reopen", default: false, null: false
    t.string "type"
    t.bigint "file_id"
    t.boolean "generated_by_system", default: false, null: false
    t.bigint "entity_id"
    t.bigint "seller_id"
    t.bigint "external_file_id"
    t.date "deliver_to_hospital"
    t.index ["company_id"], name: "index_requests_on_company_id"
    t.index ["custom_attributes"], name: "sale_requests_custom_attributes", using: :gin
    t.index ["file_id"], name: "index_requests_on_file_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "sale_points", force: :cascade do |t|
    t.bigint "company_id"
    t.boolean "active", default: true, null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_sale_points_on_company_id"
  end

  create_table "sale_resume_details", force: :cascade do |t|
    t.bigint "sale_resume_id"
    t.string "detailable_type"
    t.bigint "detailable_id"
    t.boolean "active", default: true
    t.index ["detailable_type", "detailable_id"], name: "index_sale_resume_details_on_detailable_type_and_detailable_id"
    t.index ["sale_resume_id"], name: "index_sale_resume_details_on_sale_resume_id"
  end

  create_table "sale_resumes", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.float "balance", default: 0.0
    t.datetime "last_update"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_payed", default: 0.0
    t.bigint "company_id"
    t.index ["company_id"], name: "index_sale_resumes_on_company_id"
  end

  create_table "shipment_arrivals", force: :cascade do |t|
    t.bigint "shipment_id"
    t.bigint "arrival_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_id"], name: "index_shipment_arrivals_on_arrival_id"
    t.index ["shipment_id"], name: "index_shipment_arrivals_on_shipment_id"
  end

  create_table "shipment_details", force: :cascade do |t|
    t.bigint "shipment_id"
    t.bigint "product_id"
    t.string "product_name", null: false
    t.string "product_code", null: false
    t.float "quantity", default: 0.0, null: false
    t.boolean "cumpliment", default: true, null: false
    t.text "observation"
    t.boolean "active", default: true, null: false
    t.bigint "shipment_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "product_gtin", default: [], null: false, array: true
    t.string "product_measurement"
    t.hstore "custom_attributes"
    t.boolean "custom_detail", default: false, null: false
    t.string "type"
    t.string "code"
    t.string "serial"
    t.string "due_date"
    t.string "tipo"
    t.boolean "state", default: false, null: false
    t.float "sended_quantity", default: 0.0, null: false
    t.bigint "entity_id"
    t.string "branch"
    t.integer "number"
    t.float "price", default: 0.0
    t.float "total", default: 0.0
    t.string "iva_aliquot", default: "05"
    t.decimal "iva", precision: 10, scale: 2, default: "0.21", null: false
    t.index ["entity_id"], name: "index_shipment_details_on_entity_id"
    t.index ["product_id"], name: "index_shipment_details_on_product_id"
    t.index ["shipment_id"], name: "index_shipment_details_on_shipment_id"
  end

  create_table "shipment_requests", force: :cascade do |t|
    t.bigint "shipment_id"
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_shipment_requests_on_request_id"
    t.index ["shipment_id"], name: "index_shipment_requests_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "user_id"
    t.bigint "store_id"
    t.boolean "active", default: true, null: false
    t.string "state", default: "Pendiente", null: false
    t.string "observation"
    t.date "date", default: -> { "('now'::text)::date" }, null: false
    t.bigint "entity_id"
    t.string "number", null: false
    t.hstore "custom_attributes"
    t.datetime "sended_at"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shipment_type", default: "Oficial", null: false
    t.bigint "surgery_file_id"
    t.string "type"
    t.bigint "file_id"
    t.integer "id_evento"
    t.string "from"
    t.string "to"
    t.boolean "conformed", default: false, null: false
    t.string "conformed_file"
    t.datetime "conformed_at"
    t.bigint "conformed_by"
    t.float "total", default: 0.0
    t.boolean "traslado_stock_interno", default: false
    t.index ["company_id"], name: "index_shipments_on_company_id"
    t.index ["entity_id"], name: "index_shipments_on_entity_id"
    t.index ["file_id"], name: "index_shipments_on_file_id"
    t.index ["store_id"], name: "index_shipments_on_store_id"
    t.index ["user_id"], name: "index_shipments_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "store_id"
    t.float "available", default: 0.0, null: false
    t.float "reserved", default: 0.0, null: false
    t.float "sended", default: 0.0, null: false
    t.float "delivered", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "minimum_available", default: 0.0, null: false
    t.float "recommended_available", default: 0.0, null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["store_id"], name: "index_stocks_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.string "location"
    t.boolean "active", default: true, null: false
    t.boolean "filled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store_type", default: "local", null: false
    t.index ["company_id"], name: "index_stores_on_company_id"
  end

  create_table "supplier_products", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "product_id"
    t.boolean "traceable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_supplier_products_on_entity_id"
    t.index ["product_id", "entity_id"], name: "index_supplier_products_on_product_id_and_entity_id", unique: true
    t.index ["product_id"], name: "index_supplier_products_on_product_id"
  end

  create_table "suppliers_products", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.string "code", null: false
    t.boolean "active", default: true, null: false
    t.index ["product_id"], name: "index_suppliers_products_on_product_id"
    t.index ["supplier_id"], name: "index_suppliers_products_on_supplier_id"
  end

  create_table "surgery_materials", force: :cascade do |t|
    t.string "description"
    t.string "category"
    t.string "origin"
    t.bigint "company_id"
    t.bigint "user_id"
    t.boolean "active", default: true, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id"
    t.decimal "minimum_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "maximum_price", precision: 10, scale: 2, default: "0.0"
    t.string "code"
    t.index ["company_id"], name: "index_surgery_materials_on_company_id"
    t.index ["updated_by_id"], name: "index_surgery_materials_on_updated_by_id"
    t.index ["user_id"], name: "index_surgery_materials_on_user_id"
  end

  create_table "surgery_request_details", force: :cascade do |t|
    t.bigint "surgery_request_id"
    t.string "surgery_material"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["surgery_request_id"], name: "index_surgery_request_details_on_surgery_request_id"
  end

  create_table "surgery_requests", force: :cascade do |t|
    t.string "number"
    t.bigint "user_id"
    t.bigint "company_id"
    t.date "request_date"
    t.string "surgery_type"
    t.date "surgery_date"
    t.text "observation"
    t.string "aasm_state"
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.integer "age"
    t.string "gender"
    t.string "document_type", default: "C.U.I.T.", null: false
    t.string "document_number", null: false
    t.string "address"
    t.string "mobile_phone"
    t.string "phone"
    t.bigint "province_id"
    t.bigint "locality_id"
    t.string "social_work"
    t.string "pacient_number"
    t.string "medical_history"
    t.string "institution"
    t.string "doctor"
    t.boolean "internal_stock"
    t.string "reason_for_rejection"
    t.bigint "rejected_by_id"
    t.bigint "approved_by_id"
    t.boolean "active", default: true, null: false
    t.string "surgery_time", null: false
    t.boolean "right_limb"
    t.boolean "left_limb"
    t.string "surgical_site"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dni"
    t.string "anses_negative"
    t.string "anses_no_negative"
    t.string "surgical_sheet"
    t.string "codem"
    t.string "clinical_record_cover"
    t.string "implant_certificate"
    t.bigint "file_id"
    t.string "father_dni"
    t.string "mother_dni"
    t.string "father_anses_negative"
    t.string "mother_anses_negative"
    t.string "nationality"
    t.index ["approved_by_id"], name: "index_surgery_requests_on_approved_by_id"
    t.index ["company_id"], name: "index_surgery_requests_on_company_id"
    t.index ["created_by_id"], name: "index_surgery_requests_on_created_by_id"
    t.index ["file_id"], name: "index_surgery_requests_on_file_id"
    t.index ["locality_id"], name: "index_surgery_requests_on_locality_id"
    t.index ["province_id"], name: "index_surgery_requests_on_province_id"
    t.index ["rejected_by_id"], name: "index_surgery_requests_on_rejected_by_id"
    t.index ["updated_by_id"], name: "index_surgery_requests_on_updated_by_id"
    t.index ["user_id"], name: "index_surgery_requests_on_user_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.string "tipo", null: false
    t.string "number"
    t.float "total", default: 0.0, null: false
    t.string "taxable_type"
    t.bigint "taxable_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_taxes_on_company_id"
    t.index ["taxable_type", "taxable_id"], name: "index_taxes_on_taxable_type_and_taxable_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.text "body", null: false
    t.integer "priority", default: 1, null: false
    t.integer "function_points", default: 1, null: false
    t.date "init_date"
    t.date "finish_date"
    t.string "attachment"
    t.string "state", default: "pending", null: false
    t.bigint "state_changed_by"
    t.bigint "company_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "classification"
    t.date "date"
    t.string "area"
    t.index ["company_id"], name: "index_tickets_on_company_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "tributes", force: :cascade do |t|
    t.bigint "bill_id"
    t.string "afip_id", null: false
    t.float "base_imp", default: 0.0, null: false
    t.float "alic", default: 0.0, null: false
    t.float "amount", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["bill_id"], name: "index_tributes_on_bill_id"
  end

  create_table "user_comission_limits", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.string "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_comission_limits_on_user_id"
  end

  create_table "user_comission_rewards", force: :cascade do |t|
    t.bigint "user_id"
    t.float "reward_percentage", default: 0.0
    t.string "percentage", default: "80%"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_comission_rewards_on_user_id"
  end

  create_table "user_debt_vacations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "year"
    t.integer "days"
    t.index ["user_id"], name: "index_user_debt_vacations_on_user_id"
  end

  create_table "user_table_configs", force: :cascade do |t|
    t.string "table"
    t.bigint "user_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_table_configs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "document_type"
    t.string "document_number"
    t.date "birthday"
    t.string "address"
    t.string "postal_code"
    t.boolean "active", default: true, null: false
    t.string "avatar", default: "/images/default_user.png", null: false
    t.string "phone"
    t.string "mobile_phone"
    t.boolean "approved", default: false, null: false
    t.boolean "company_owner", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "company_id"
    t.bigint "locality_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.bigint "store_id"
    t.integer "machine_id"
    t.string "status", default: "Activo"
    t.date "start_of_activity"
    t.string "contract"
    t.boolean "talliable", default: true
    t.string "position"
    t.bigint "work_station_id"
    t.bigint "file_number"
    t.string "social_work"
    t.boolean "bill_due_notification", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["locality_id"], name: "index_users_on_locality_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
    t.index ["work_station_id"], name: "index_users_on_work_station_id"
  end

  create_table "vacation_debt_asignations", force: :cascade do |t|
    t.bigint "user_vacation_id"
    t.bigint "user_debt_vacation_id"
    t.integer "days"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "work_stations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "responsable_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_work_stations_on_company_id"
  end

  add_foreign_key "abilities", "roles"
  add_foreign_key "ability_actions", "abilities"
  add_foreign_key "account_movements", "bills"
  add_foreign_key "account_movements", "entities"
  add_foreign_key "account_movements", "payment_orders"
  add_foreign_key "account_movements", "receipts"
  add_foreign_key "activities", "companies"
  add_foreign_key "activities", "users"
  add_foreign_key "alerts", "companies"
  add_foreign_key "alerts", "users"
  add_foreign_key "arrival_details", "arrivals"
  add_foreign_key "arrival_details", "products"
  add_foreign_key "arrivals", "companies"
  add_foreign_key "arrivals", "entities"
  add_foreign_key "arrivals", "files"
  add_foreign_key "arrivals", "stores"
  add_foreign_key "arrivals", "users"
  add_foreign_key "arrivals_orders", "arrivals"
  add_foreign_key "arrivals_orders", "orders"
  add_foreign_key "arrivals_requests", "arrivals"
  add_foreign_key "arrivals_requests", "requests"
  add_foreign_key "attendance_categories", "companies"
  add_foreign_key "attendance_category_users", "attendance_categories"
  add_foreign_key "attendance_category_users", "users"
  add_foreign_key "attendance_resumes", "companies"
  add_foreign_key "attendances", "attendance_resumes"
  add_foreign_key "attendances", "users"
  add_foreign_key "bank_account_importer_configurations", "bank_accounts"
  add_foreign_key "bank_account_movements", "bank_accounts"
  add_foreign_key "bank_account_movements", "entities", column: "supplier_id"
  add_foreign_key "bank_account_transactions", "bank_accounts"
  add_foreign_key "bank_accounts", "banks"
  add_foreign_key "banks", "companies"
  add_foreign_key "batch_details", "batches"
  add_foreign_key "batch_details", "stores"
  add_foreign_key "batch_stores", "batches"
  add_foreign_key "batch_stores", "stores"
  add_foreign_key "batches", "arrival_details"
  add_foreign_key "batches", "devolution_details"
  add_foreign_key "batches", "products"
  add_foreign_key "batches", "shipment_details"
  add_foreign_key "batches", "supplier_products"
  add_foreign_key "bill_arrivals", "arrivals"
  add_foreign_key "bill_arrivals", "bills"
  add_foreign_key "bill_details", "bills"
  add_foreign_key "bill_details", "products"
  add_foreign_key "bill_movements", "bills"
  add_foreign_key "bill_optionals", "bills"
  add_foreign_key "bill_shipments", "bills"
  add_foreign_key "bill_shipments", "shipments"
  add_foreign_key "bills", "companies"
  add_foreign_key "bills", "entities"
  add_foreign_key "bills", "files"
  add_foreign_key "bills", "payment_types"
  add_foreign_key "bills", "users"
  add_foreign_key "bills_orders", "bills"
  add_foreign_key "bills_orders", "orders"
  add_foreign_key "box_products", "products"
  add_foreign_key "budget_details", "budgets"
  add_foreign_key "budget_details", "products"
  add_foreign_key "budgets", "companies"
  add_foreign_key "budgets", "entities"
  add_foreign_key "budgets", "entity_contacts"
  add_foreign_key "budgets", "files"
  add_foreign_key "budgets", "users"
  add_foreign_key "budgets_requests", "budgets"
  add_foreign_key "budgets_requests", "requests"
  add_foreign_key "cards", "banks"
  add_foreign_key "cards", "companies"
  add_foreign_key "cash_account_logs", "cash_accounts"
  add_foreign_key "cash_account_logs", "users"
  add_foreign_key "cash_accounts", "companies"
  add_foreign_key "cash_accounts", "users"
  add_foreign_key "cash_refunds", "cash_solicitudes"
  add_foreign_key "cash_refunds", "users"
  add_foreign_key "cash_solicitudes", "companies"
  add_foreign_key "cash_solicitudes", "users"
  add_foreign_key "cash_solicitudes", "users", column: "evaluador_id"
  add_foreign_key "cash_withdrawals", "cash_solicitudes"
  add_foreign_key "cash_withdrawals", "users"
  add_foreign_key "check_amends", "emitted_checks"
  add_foreign_key "checkbooks", "bank_accounts"
  add_foreign_key "comments", "users"
  add_foreign_key "companies", "localities"
  add_foreign_key "consumptions_shipments", "shipments"
  add_foreign_key "cost_sub_categories", "cost_categories"
  add_foreign_key "daily_cash_balances", "cash_accounts"
  add_foreign_key "daily_cash_balances", "users"
  add_foreign_key "departments", "companies"
  add_foreign_key "departments", "users"
  add_foreign_key "devolution_arrivals", "arrivals"
  add_foreign_key "devolution_arrivals", "devolutions"
  add_foreign_key "devolution_consumptions", "devolutions"
  add_foreign_key "devolution_details", "devolutions"
  add_foreign_key "devolution_details", "products"
  add_foreign_key "devolution_shipments", "devolutions"
  add_foreign_key "devolution_shipments", "shipments"
  add_foreign_key "devolutions", "companies"
  add_foreign_key "devolutions", "entities"
  add_foreign_key "devolutions", "files"
  add_foreign_key "devolutions", "stores"
  add_foreign_key "devolutions", "users"
  add_foreign_key "devolutions_arrivals", "arrivals"
  add_foreign_key "devolutions_arrivals", "devolutions"
  add_foreign_key "emitted_checks", "checkbooks"
  add_foreign_key "emitted_checks", "companies"
  add_foreign_key "emitted_checks", "entities"
  add_foreign_key "emitted_checks", "payment_orders"
  add_foreign_key "entities", "companies"
  add_foreign_key "entities", "localities"
  add_foreign_key "entities", "payment_types"
  add_foreign_key "entities", "provinces"
  add_foreign_key "entity_banks", "entities"
  add_foreign_key "entity_contacts", "entities"
  add_foreign_key "entity_records", "entity_contacts"
  add_foreign_key "entity_records", "users"
  add_foreign_key "expenditures", "companies"
  add_foreign_key "expenditures", "entities"
  add_foreign_key "expense_details", "cash_accounts"
  add_foreign_key "expense_details", "cash_solicitudes"
  add_foreign_key "expense_details", "companies"
  add_foreign_key "expense_details", "entities"
  add_foreign_key "expense_details", "orders"
  add_foreign_key "expenses", "cash_accounts"
  add_foreign_key "expenses", "companies"
  add_foreign_key "expenses", "users"
  add_foreign_key "file_attributes_configs", "companies"
  add_foreign_key "file_responsables", "files"
  add_foreign_key "file_responsables", "users"
  add_foreign_key "files", "companies"
  add_foreign_key "files", "entities"
  add_foreign_key "files", "users"
  add_foreign_key "hidden_attributes", "user_table_configs"
  add_foreign_key "imprest_clearings", "users"
  add_foreign_key "incomes", "cash_accounts"
  add_foreign_key "incomes", "companies"
  add_foreign_key "incomes", "users"
  add_foreign_key "justifications", "companies"
  add_foreign_key "justifications", "users"
  add_foreign_key "localities", "provinces"
  add_foreign_key "locations", "shipments"
  add_foreign_key "non_present_users", "attendances"
  add_foreign_key "non_present_users", "users"
  add_foreign_key "non_working_day_details", "non_working_days"
  add_foreign_key "non_working_day_details", "users"
  add_foreign_key "non_working_days", "companies"
  add_foreign_key "notifications", "companies"
  add_foreign_key "notifications", "departments"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
  add_foreign_key "order_details", "users"
  add_foreign_key "order_payment_days", "payment_types"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "entities"
  add_foreign_key "orders", "files"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "users"
  add_foreign_key "orders_budgets", "budgets"
  add_foreign_key "orders_budgets", "orders"
  add_foreign_key "orders_requests", "orders"
  add_foreign_key "orders_requests", "requests"
  add_foreign_key "orders_shipments", "orders"
  add_foreign_key "orders_shipments", "shipments"
  add_foreign_key "payment_order_bills", "checkbooks"
  add_foreign_key "payment_order_bills", "payment_types"
  add_foreign_key "payment_order_payments", "bank_accounts"
  add_foreign_key "payment_order_payments", "checkbooks"
  add_foreign_key "payment_order_payments", "payment_orders"
  add_foreign_key "payment_order_payments", "payment_types"
  add_foreign_key "payment_orders", "companies"
  add_foreign_key "payment_orders", "entities"
  add_foreign_key "payment_orders", "files"
  add_foreign_key "payment_orders", "order_payment_days"
  add_foreign_key "payment_orders", "orders"
  add_foreign_key "payment_orders", "users"
  add_foreign_key "payment_types", "cash_accounts"
  add_foreign_key "payment_types", "companies"
  add_foreign_key "price_histories", "entities"
  add_foreign_key "price_histories", "products"
  add_foreign_key "price_updates", "companies"
  add_foreign_key "price_updates", "users"
  add_foreign_key "price_updates", "users", column: "created_by_id"
  add_foreign_key "product_categories", "companies"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "promissory_payments", "bank_accounts"
  add_foreign_key "promissory_payments", "companies"
  add_foreign_key "promissory_payments", "entities"
  add_foreign_key "promissory_payments", "receipts"
  add_foreign_key "provinces", "countries"
  add_foreign_key "receipts", "companies"
  add_foreign_key "receipts", "entities"
  add_foreign_key "receipts", "files"
  add_foreign_key "receipts", "users"
  add_foreign_key "receipts_bills", "bills"
  add_foreign_key "receipts_bills", "receipts"
  add_foreign_key "receipts_payments", "bank_accounts"
  add_foreign_key "receipts_payments", "payment_types"
  add_foreign_key "receipts_payments", "receipts"
  add_foreign_key "request_details", "products"
  add_foreign_key "request_details", "requests"
  add_foreign_key "requests", "companies"
  add_foreign_key "requests", "entities"
  add_foreign_key "requests", "files"
  add_foreign_key "requests", "users"
  add_foreign_key "roles", "companies"
  add_foreign_key "sale_points", "companies"
  add_foreign_key "sale_resume_details", "sale_resumes"
  add_foreign_key "sale_resumes", "companies"
  add_foreign_key "shipment_arrivals", "arrivals"
  add_foreign_key "shipment_arrivals", "shipments"
  add_foreign_key "shipment_details", "entities"
  add_foreign_key "shipment_details", "products"
  add_foreign_key "shipment_details", "shipments"
  add_foreign_key "shipment_requests", "requests"
  add_foreign_key "shipment_requests", "shipments"
  add_foreign_key "shipments", "companies"
  add_foreign_key "shipments", "entities"
  add_foreign_key "shipments", "files"
  add_foreign_key "shipments", "stores"
  add_foreign_key "shipments", "users"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "stores"
  add_foreign_key "stores", "companies"
  add_foreign_key "supplier_products", "entities"
  add_foreign_key "supplier_products", "products"
  add_foreign_key "suppliers_products", "entities", column: "supplier_id"
  add_foreign_key "suppliers_products", "products"
  add_foreign_key "surgery_materials", "companies"
  add_foreign_key "surgery_materials", "users"
  add_foreign_key "surgery_materials", "users", column: "updated_by_id"
  add_foreign_key "surgery_request_details", "surgery_requests"
  add_foreign_key "surgery_requests", "companies"
  add_foreign_key "surgery_requests", "localities"
  add_foreign_key "surgery_requests", "provinces"
  add_foreign_key "surgery_requests", "users"
  add_foreign_key "surgery_requests", "users", column: "approved_by_id"
  add_foreign_key "surgery_requests", "users", column: "created_by_id"
  add_foreign_key "surgery_requests", "users", column: "rejected_by_id"
  add_foreign_key "surgery_requests", "users", column: "updated_by_id"
  add_foreign_key "tickets", "companies"
  add_foreign_key "tickets", "users"
  add_foreign_key "tributes", "bills"
  add_foreign_key "user_comission_limits", "users"
  add_foreign_key "user_comission_rewards", "users"
  add_foreign_key "user_debt_vacations", "users"
  add_foreign_key "user_table_configs", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "localities"
  add_foreign_key "users", "stores"
  add_foreign_key "users", "work_stations"
  add_foreign_key "work_stations", "companies"
end
