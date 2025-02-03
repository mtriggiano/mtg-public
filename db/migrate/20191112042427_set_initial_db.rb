class SetInitialDb < ActiveRecord::Migration[5.2]
  def up
    enable_extension "hstore"
    enable_extension "plpgsql"

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
    t.index ["entity_id"], name: "index_account_movements_on_entity_id"
    t.index ["bill_id"], name: "index_account_movements_on_bill_id"
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
    t.index ["company_id"], name: "index_activities_on_company_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
    t.index ["activitable_type", "activitable_id"], name: "index_attachments_on_activitable_type_and_activitable_id"
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
    t.index ["company_id"], name: "index_alerts_on_company_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
    t.index ["alertable_type", "alertable_id"], name: "index_attachments_on_alertable_type_and_alertable_id"
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
    t.index ["company_id"], name: "index_arrivals_on_company_id"
    t.index ["file_id"], name: "index_arrivals_on_file_id"
    t.index ["store_id"], name: "index_arrivals_on_store_id"
    t.index ["entity_id"], name: "index_arrivals_on_entity_id"
    t.index ["user_id"], name: "index_arrivals_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "file", default: "/images/attachment.png", null: false
    t.string "original_filename", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name", null: false
    t.string "cbu", limit: 22
    t.string "account_number"
    t.decimal "current_amount", default: "0.0", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.index ["company_id"], name: "index_banks_on_company_id"
  end

  create_table "batches", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.float "available", default: 0.0, null: false
    t.bigint "user_id"
    t.bigint "product_id"
    t.bigint "store_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_date"
    t.bigint "arrival_detail_id"
    t.string "code"
    t.index ["product_id"], name: "index_batches_on_product_id"
    t.index ["arrival_detail_id"], name: "index_batches_on_arrival_detail_id"
    t.index ["store_id"], name: "index_batches_on_store_id"
    t.index ["entity_id"], name: "index_batches_on_entity_id"
    t.index ["user_id"], name: "index_batches_on_user_id"
  end

  create_table "bills", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "state", default: "Pendiente", null: false
    t.float "total", default: 0.0, null: false
    t.float "total_pay", default: 0.0, null: false
    t.float "total_left", default: 0.0, null: false
    t.string "sale_point", null: false
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
    t.index ["entity_id"], name: "index_bills_on_entity_id"
    t.index ["company_id"], name: "index_bills_on_company_id"
    t.index ["file_id"], name: "index_bills_on_file_id"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "box_products", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "cirgury_box_id"
    t.float "quantity"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_box_products_on_product_id"
  end

  create_table "budget_details", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "product_name", null: false
    t.string "product_code", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "Pendiente", null: false
    t.string "product_measurement", null: false
    t.string "detail_type", default: "Consumo", null: false
    t.string "iva_aliquot", default: "05", null: false
    t.boolean "ordered", default: false, null: false
    t.text "description"
    t.bigint "budget_detail_id"
    t.bigint "budget_id"
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
    t.index ["entity_contact_id"], name: "index_budgets_on_entity_contact_id"
    t.index ["entity_id"], name: "index_budgets_on_entity_id"
    t.index ["company_id"], name: "index_budgets_on_company_id"
    t.index ["file_id"], name: "index_budgets_on_file_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
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

  create_table "checkbooks", force: :cascade do |t|
    t.string "number"
    t.string "init_number"
    t.string "final_number"
    t.bigint "bank_id"
    t.bigint "company_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_checkbooks_on_bank_id"
    t.index ["company_id"], name: "index_checkbooks_on_company_id"
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
    t.index ["company_id"], name: "index_entities_on_company_id"
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
    t.index ["locality_id"], name: "index_companies_on_locality_id"
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

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
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
    t.index ["entity_id"], name: "index_files_on_entity_id"
    t.index ["company_id"], name: "index_files_on_company_id"
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

  create_table "localities", force: :cascade do |t|
    t.bigint "province_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["province_id"], name: "index_localities_on_province_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "department_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.string "parent", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.string "date", default: -> { "('now'::text)::date" }, null: false
    t.boolean "seen", default: false, null: false
    t.boolean "active", default: true, null: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_notifications_on_company_id"
    t.index ["department_id"], name: "index_notifications_on_department_id"
    t.index ["role_id"], name: "index_notifications_on_role_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "product_name", null: false
    t.string "product_code", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.float "discount", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_measurement", null: false
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
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
    t.index ["user_id"], name: "index_order_details_on_user_id"
  end

  create_table "order_payment_days", force: :cascade do |t|
    t.date "date"
    t.boolean "paid", default: false, null: false
    t.boolean "active"
    t.string "payable_type"
    t.bigint "payable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payable_id", "payable_type"], name: "index_order_payment_days_on_payable_id_and_payable_type"
    t.index ["payable_type", "payable_id"], name: "index_order_payment_days_on_payable_type_and_payable_id"
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
    t.index ["entity_id"], name: "index_orders_on_entity_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["file_id"], name: "index_orders_on_file_id"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "orders_requests", id: false, force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "order_id", null: false
    t.string "type", null: false
    t.index ["order_id", "request_id"], name: "index_orders_requests_on_order_id_and_request_id"
    t.index ["request_id", "order_id"], name: "index_orders_requests_on_request_id_and_order_id"
  end

  create_table "payment_types", force: :cascade do |t|
    t.datetime "date"
    t.float "total"
    t.boolean "active", default: true
    t.string "type"
    t.date "due_date"
    t.string "receiver"
    t.boolean "nominative"
    t.string "walletable_type"
    t.bigint "walletable_id"
    t.string "state", default: "Pendiente de pago"
    t.string "origin"
    t.string "number"
    t.boolean "crossed", default: false
    t.boolean "endosed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["walletable_type", "walletable_id"], name: "index_payment_types_on_walletable_type_and_walletable_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.string "default_iva", default: "05", null: false
    t.boolean "active", default: true, null: false
    t.integer "products_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_product_categories_on_company_id"
  end

  create_table "price_histories", force: :cascade do |t|
    t.bigint "product_id"
    t.string "currency", default: "PES", null: false
    t.float "price", default: 0.0, null: false
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_price_histories_on_product_id"
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
    t.float "recommended_stock"
    t.float "available_stock", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_type", default: "regular", null: false
    t.boolean "traceable", default: true, null: false
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["country_id"], name: "index_provinces_on_country_id"
  end

  create_table "arrival_details", force: :cascade do |t|
    t.bigint "arrival_id"
    t.bigint "product_id"
    t.string "product_name", null: false
    t.string "product_code", null: false
    t.string "product_measurement", null: false
    t.float "requested_quantity", null: false
    t.float "quantity", default: 0.0, null: false
    t.boolean "cumpliment", default: true, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "arrival_detail_id"
    t.string "type"

    t.text "description"
    t.index ["product_id"], name: "index_arrival_details_on_product_id"
    t.index ["arrival_id"], name: "index_arrival_details_on_arrival_id"
  end

  create_table "arrivals_orders", id: false, force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "arrival_id"
    t.boolean "active", default: true, null: false
    t.index ["arrival_id"], name: "index_arrivals_orders_on_arrival_id"
    t.index ["order_id"], name: "index_arrivals_orders_on_order_id"
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
    t.index ["product_id"], name: "index_budget_details_on_product_id"
    t.index ["budget_id"], name: "index_budget_details_on_budget_id"
  end

  create_table "budgets_requests", id: false, force: :cascade do |t|
    t.bigint "budget_id"
    t.bigint "request_id"
    t.boolean "active", default: true, null: false
    t.index ["budget_id"], name: "index_budgets_requests_on_budget_id"
    t.index ["request_id"], name: "index_budgets_requests_on_request_id"
  end

  create_table "orders_budgets", id: false, force: :cascade do |t|
    t.bigint "orders_id"
    t.bigint "budget_id"
    t.boolean "active", default: true, null: false
    t.index ["budget_id"], name: "index_orders_budgets_on_budget_id"
    t.index ["orders_id"], name: "index_orders_budgets_on_orders_id"
  end

  create_table "orders_shipments", id: false, force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "shipment_id"
    t.boolean "active", default: true, null: false
    t.string "type", null: false
    t.index ["order_id"], name: "index_orders_shipments_on_order_id"
    t.index ["shipment_id"], name: "index_orders_shipments_on_shipment_id"
  end

  create_table "returns_arrivals", id: false, force: :cascade do |t|
    t.bigint "return_id"
    t.bigint "arrival_id"
    t.boolean "active", default: true, null: false
    t.index ["arrival_id"], name: "index_returns_arrivals_on_arrival_id"
    t.index ["return_id"], name: "index_returns_arrivals_on_return_id"
  end

  create_table "return_details", force: :cascade do |t|
    t.bigint "return_id"
    t.bigint "product_id"
    t.float "quantity", default: 0.0, null: false
    t.string "return_reason", null: false
    t.string "product_name", null: false
    t.string "product_supplier_code", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "return_detail_id"
    t.string "product_measurement", default: "unidades", null: false
    t.bigint "batch_id"
    t.index ["batch_id"], name: "index_return_details_on_batch_id"
    t.index ["product_id"], name: "index_return_details_on_product_id"
    t.index ["return_id"], name: "index_return_details_on_return_id"
  end

  create_table "returns", force: :cascade do |t|
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
    t.index ["company_id"], name: "index_returns_on_company_id"
    t.index ["file_id"], name: "index_returns_on_file_id"
    t.index ["entity_id"], name: "index_returns_on_entity_id"
    t.index ["user_id"], name: "index_returns_on_user_id"
  end

  create_table "request_details", force: :cascade do |t|
    t.bigint "product_id"
    t.string "product_name", null: false
    t.string "product_measurement", null: false
    t.float "quantity", default: 0.0, null: false
    t.float "approved_quantity", default: 0.0, null: false
    t.string "description"
    t.string "state", default: "Pendiente", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_code"
    t.string "detail_type", default: "Consumo", null: false
    t.boolean "budgeted", default: false, null: false
    t.bigint "request_detail_id"
    t.bigint "request_id"
    t.hstore "custom_attributes"
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
    t.index ["company_id"], name: "index_requests_on_company_id"
    # t.index ["custom_attributes"], name: "sale_requests_custom_attributes", using: :gin
    t.index ["file_id"], name: "index_requests_on_file_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "role_abilities", force: :cascade do |t|
    t.string "action_name"
    t.string "description"
    t.bigint "role_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_abilities_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "friendly_name"
    t.string "class_name"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bill_details", force: :cascade do |t|
    t.float "quantity", default: 0.0, null: false
    t.string "product_name", null: false
    t.string "product_code", null: false
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
    t.index ["product_id"], name: "index_bill_details_on_product_id"
    t.index ["bill_id"], name: "index_bill_details_on_bill_id"
  end

  create_table "bills_orders", id: false, force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "order_id"
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.index ["bill_id"], name: "index_bills_orders_on_bill_id"
    t.index ["order_id"], name: "index_bills_orders_on_order_id"
  end

  create_table "budgets_requests", id: false, force: :cascade do |t|
    t.string "active", default: "t", null: false
    t.bigint "budget_id"
    t.bigint "request_id"
    t.string "type", null: false
    t.index ["budget_id"], name: "index_budgets_requests_on_budget_id"
    t.index ["request_id"], name: "index_budgets_requests_on_request_id"
  end

  create_table "orders_budgets", id: false, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "budget_id"
    t.bigint "order_id"
    t.string "type", null: false
    t.index ["budget_id"], name: "index_orders_budgets_on_budget_id"
    t.index ["order_id"], name: "index_orders_budgets_on_order_id"
  end

  create_table "sale_points", force: :cascade do |t|
    t.bigint "company_id"
    t.boolean "active", default: true, null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_sale_points_on_company_id"
  end

  create_table "receipts_bills", id: false, force: :cascade do |t|
    t.bigint "bill_id"
    t.bigint "receipt_id"
    t.float "total", default: 0.0, null: false
    t.boolean "active", default: true, null: false
    t.string "type", null: false
    t.string "payment_type", default: "Contado", null: false
    t.index ["bill_id"], name: "index_receipts_bills_on_bill_id"
    t.index ["receipt_id"], name: "index_receipts_bills_on_receipt_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "file_id"
    t.bigint "company_id"
    t.bigint "sale_point_id"
    t.bigint "user_id"
    t.boolean "active", default: true, null: false
    t.float "total", default: 0.0, null: false
    t.date "date", default: -> { "('now'::text)::date" }, null: false
    t.text "concept"
    t.string "number", null: false
    t.string "state", default: "Pendiente", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "custom_attributes"
    t.index ["entity_id"], name: "index_receipts_on_entity_id"
    t.index ["company_id"], name: "index_receipts_on_company_id"
    t.index ["file_id"], name: "index_receipts_on_file_id"
    t.index ["sale_point_id"], name: "index_receipts_on_sale_point_id"
    t.index ["user_id"], name: "index_receipts_on_user_id"
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
    t.index ["product_id"], name: "index_shipment_details_on_product_id"
    t.index ["shipment_id"], name: "index_shipment_details_on_shipment_id"
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
    t.index ["entity_id"], name: "index_shipments_on_entity_id"
    t.index ["company_id"], name: "index_shipments_on_company_id"
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

  create_table "suppliers_products", id: false, force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "product_id"
    t.string "code", null: false
    t.boolean "active", default: true, null: false
    t.index ["product_id"], name: "index_suppliers_products_on_product_id"
    t.index ["supplier_id"], name: "index_suppliers_products_on_supplier_id"
  end

  create_table "arrivals_requests", if: false, force: :cascade do |t|
    t.bigint "arrival_id"
    t.bigint "request_id"
    t.string "type"
    t.boolean "active", default: true, null: false
    t.index ["arrival_id"], name: "index_arrivals_requests_on_arrival_id"
    t.index ["request_id"], name: "index_arrivals_requests_on_request_id"
  end

  create_table "consumptions_shipments", force: :cascade do |t|
    t.bigint "shipment_id"
    t.bigint "consumption_id"
    t.boolean "active", default: true, null: false
    t.string "type", null: false
    t.index ["shipment_id"], name: "index_consumptions_shipments_on_shipment_id"
  end

  create_table "unit_gtins", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "batch_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "state", default: true, null: false
    t.bigint "arrival_detail_id"
    t.bigint "shipment_detail_id"
    t.string "code"
    t.bigint "return_detail_id"
    t.index ["code", "shipment_detail_id"]
    t.index ["code", "arrival_detail_id"]
    t.index ["batch_id"], name: "index_unit_gtins_on_batch_id"
    t.index ["product_id"], name: "index_unit_gtins_on_product_id"
    t.index ["arrival_detail_id"], name: "index_unit_gtins_on_arrival_detail_id"
    t.index ["return_detail_id"], name: "index_unit_gtins_on_return_detail_id"
    t.index ["shipment_detail_id"], name: "index_unit_gtins_on_shipment_detail_id"
  end

  create_table "user_abilities", force: :cascade do |t|
    t.bigint "user_role_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_ability_id"
    t.index ["role_ability_id"], name: "index_user_abilities_on_role_ability_id"
    t.index ["user_role_id"], name: "index_user_abilities_on_user_role_id"
  end

  create_table "user_alerts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "alert_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id"], name: "index_user_alerts_on_alert_id"
    t.index ["user_id"], name: "index_user_alerts_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["locality_id"], name: "index_users_on_locality_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
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

  add_foreign_key "account_movements", "bills", column: "bill_id"
  add_foreign_key "account_movements", "entities"
  add_foreign_key "account_movements", "receipts"
  add_foreign_key "activities", "companies"
  add_foreign_key "activities", "users"
  add_foreign_key "alerts", "companies"
  add_foreign_key "alerts", "users"
  add_foreign_key "arrivals", "companies"
  add_foreign_key "arrivals", "files"
  add_foreign_key "arrivals", "stores"
  add_foreign_key "arrivals", "entities"
  add_foreign_key "arrivals", "users"
  add_foreign_key "banks", "companies"
  add_foreign_key "batches", "products"
  add_foreign_key "batches", "arrival_details"
  add_foreign_key "batches", "entities"
  add_foreign_key "batches", "users"
  add_foreign_key "bills", "entities"
  add_foreign_key "bills", "companies"
  add_foreign_key "bills", "files"
  add_foreign_key "bills", "users"
  add_foreign_key "box_products", "products"
  add_foreign_key "budget_details", "budgets"
  add_foreign_key "budget_details", "products"
  add_foreign_key "budgets", "entity_contacts"
  add_foreign_key "budgets", "entities"
  add_foreign_key "budgets", "companies"
  add_foreign_key "budgets", "files"
  add_foreign_key "budgets", "users"
  add_foreign_key "cards", "banks"
  add_foreign_key "cards", "companies"
  add_foreign_key "checkbooks", "banks"
  add_foreign_key "checkbooks", "companies"
  add_foreign_key "entity_contacts", "entities"
  add_foreign_key "entities", "companies"
  add_foreign_key "companies", "localities"
  add_foreign_key "entity_records", "entity_contacts"
  add_foreign_key "entity_records", "users"
  add_foreign_key "departments", "companies"
  add_foreign_key "departments", "users"
  add_foreign_key "file_attributes_configs", "companies"
  add_foreign_key "file_responsables", "files"
  add_foreign_key "file_responsables", "users"
  add_foreign_key "files", "entities"
  add_foreign_key "files", "companies"
  add_foreign_key "files", "users"
  add_foreign_key "hidden_attributes", "user_table_configs"
  add_foreign_key "localities", "provinces"
  add_foreign_key "notifications", "companies"
  add_foreign_key "notifications", "departments"
  add_foreign_key "notifications", "roles"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
  add_foreign_key "order_details", "users"
  add_foreign_key "orders", "entities"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "files"
  add_foreign_key "orders", "users"
  add_foreign_key "product_categories", "companies"
  add_foreign_key "price_histories", "products"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "provinces", "countries"
  add_foreign_key "arrival_details", "arrivals", column: "arrival_id"
  add_foreign_key "arrival_details", "products"
  add_foreign_key "arrivals_orders", "arrivals", column: "arrival_id"
  add_foreign_key "arrivals_orders", "orders", column: "order_id"
  add_foreign_key "orders_shipments", "orders", column: "order_id"
  add_foreign_key "orders_shipments", "shipments", column: "shipment_id"
  add_foreign_key "orders", "stores"
  add_foreign_key "request_details", "products"
  add_foreign_key "request_details", "requests"
  add_foreign_key "orders_requests", "orders", column: "order_id"
  add_foreign_key "orders_requests", "requests", column: "request_id"
  add_foreign_key "requests", "companies"
  add_foreign_key "requests", "files"
  add_foreign_key "requests", "entities"
  add_foreign_key "requests", "users"
  add_foreign_key "returns_arrivals", "arrivals", column: "arrival_id"
  add_foreign_key "returns_arrivals", "returns", column: "return_id"
  add_foreign_key "return_details", "products"
  add_foreign_key "return_details", "returns"
  add_foreign_key "returns", "companies"
  add_foreign_key "returns", "files"
  add_foreign_key "returns", "entities"
  add_foreign_key "returns", "users"
  add_foreign_key "role_abilities", "roles"
  add_foreign_key "bill_details", "bills", column: "bill_id"
  add_foreign_key "bill_details", "products"
  add_foreign_key "bills_orders", "bills", column: "bill_id"
  add_foreign_key "bills_orders", "orders", column: "order_id"
  add_foreign_key "budgets_requests", "budgets", column: "budget_id"
  add_foreign_key "budgets_requests", "requests", column: "request_id"
  add_foreign_key "orders_budgets", "budgets", column: "budget_id"
  add_foreign_key "orders_budgets", "orders", column: "order_id"
  add_foreign_key "sale_points", "companies"
  add_foreign_key "receipts_bills", "bills", column: "bill_id"
  add_foreign_key "receipts_bills", "receipts", column: "receipt_id"
  add_foreign_key "receipts", "entities"
  add_foreign_key "receipts", "companies"
  add_foreign_key "receipts", "files", column: "file_id"
  add_foreign_key "receipts", "sale_points"
  add_foreign_key "receipts", "users"
  add_foreign_key "sale_resume_details", "sale_resumes"
  add_foreign_key "sale_resumes", "companies"
  add_foreign_key "shipment_details", "products"
  add_foreign_key "shipment_details", "shipments", column: "shipment_id"
  add_foreign_key "shipments", "entities"
  add_foreign_key "shipments", "companies"
  add_foreign_key "shipments", "files"
  add_foreign_key "shipments", "stores"
  add_foreign_key "shipments", "users"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "stores"
  add_foreign_key "stores", "companies"
  add_foreign_key "suppliers_products", "products", column: "product_id"
  add_foreign_key "suppliers_products", "entities", column: "supplier_id"
  add_foreign_key "arrivals_requests", "arrivals", column: "arrival_id"
  add_foreign_key "arrivals_requests", "requests", column: "request_id"
  add_foreign_key "consumptions_shipments", "shipments", column: "shipment_id"
  add_foreign_key "unit_gtins", "batches"
  add_foreign_key "unit_gtins", "products"
  add_foreign_key "unit_gtins", "arrival_details"
  add_foreign_key "unit_gtins", "shipment_details"
  add_foreign_key "user_abilities", "role_abilities"
  add_foreign_key "user_abilities", "user_roles"
  add_foreign_key "user_alerts", "alerts"
  add_foreign_key "user_alerts", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_table_configs", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "localities"
  add_foreign_key "users", "stores"
  end
end
