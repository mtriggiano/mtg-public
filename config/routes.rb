Rails.application.routes.draw do
  
  resources :tickets do
    member do
      post :start
      post :finish
    end
  end
  mount ReportsKit::Engine, at: '/'

  resources :attachments, only: [:edit, :update]

  namespace :reports do
    resources :clients, only: [:index, :show]
    resources :receipts, only: :index
    resources :bills, only: :index
    resources :bill_details, only: :index
    resources :shipments, only: :index
    resources :shipment_details, only: :index
    resources :finances, only: :index
    resources :buy_iva_movements, only: :index
    resources :sell_iva_movements, only: :index do
      get :export, on: :collection
    end
    resources :storages, only: [:index] do
      get :for_calendar, on: :collection
      get :export_arrival_products, on: :collection
      get :export_batches, on: :collection
    end
    resources :purchases do
      get :costing, on: :member
    end
    resources :suppliers
  end

  resources :bill_movements

	get 'home', to: "home#index"
  get '/eventos', to: 'application#eventos', as: :eventos
  get '/forbidden', to: 'home#forbidden', as: 'forbidden'
  get '/get_padron', to: 'application#get_padron'
  get '/get_provinces/:country_id', to: 'application#get_provinces'
	get '/consultar_localidades/:province_id', to: 'provinces#consultar_localidades'

  resources :user_table_configs, only: [:create, :destroy]
	devise_for :users, controllers: {
      sessions: 		'users/sessions',
      registrations: 	'users/registrations',
      passwords: 		'users/passwords',
      confirmations:  'users/confirmations',
      invitations: 'users/invitations'
  }

  devise_scope :user do
    authenticated :user do
      root "home#index"
    end
    unauthenticated :user do
      root "users/sessions#new"
    end
  end

  namespace :api, path: "/", defaults: {format: "json"} do
    namespace :v1 do
      resources :attendances do
        post :load, on: :collection
      end
    end
  end

  resources :alerts
  resources :roles
  resources :croppers, only: :new

  resources :expedient_requests
  resources :expedient_orders
  resources :expedient_arrivals

  scope module: :human_resources, path: '/human_resources' do
    resources :attendance_resumes do
      post :import, on: :collection
      resources :attendances
    end
    resources :attendance_categories
    resources :day_attendances
    resources :non_working_days
    resources :non_present_users
    resources :work_stations
    resources :user_vacations do
      get :fill_days_asignations, on: :collection
      get :get_max_days_for_vac_days, on: :collection
      get :set_approve_params, on: :member
      patch :approve, on: :member
    end
    resources :permissions do
      get :set_approve_params, on: :member
      patch :approve, on: :member
    end
    resources :users, except: [:show_alert, :new_alert, :edit_alert, :update_alert, :destroy_alert, :create_alert, :become] do
      get :profile, on: :member
      get :month_comissions, on: :member
      get :client_comissions, on: :member
      get :month_comissions_quantity, on: :member
      get :client_comissions_quantity, on: :member
      get :edit, on: :member
      patch :set_role, on: :member
      resources :attendances
      resources :user_roles
      resources :roles
    end
  end
  scope module: :employees, path: '/employees' do
    resources :users, only: [:show_alert, :new_alert, :edit_alert, :update_alert, :destroy_alert, :create_alert, :become] do
      get     :show_alert, on: :member
      get     :new_alert, on: :member
      get     :edit_alert, on: :member
      patch   :update_alert, on: :member
      delete  :destroy_alert, on: :member
      post    :create_alert, on: :member
      post :become, on: :collection
    end
  end


  # resources :users, only: [:show, :update] do
  #   get     :show_alert, on: :member
  #   get     :new_alert, on: :member
  #   get     :edit_alert, on: :member
  #   patch   :update_alert, on: :member
  #   delete  :destroy_alert, on: :member
  #   post    :create_alert, on: :member
  #   post :become, on: :collection
  #   resources :user_roles do
  #     get :descriptions_by_role, on: :collection
  #   end
  # end

  resources :companies do
    member do
      get :charts_filter
      get :vendor_charts
      get :vendor_client_charts
      get :vendor_charts_quantity
      get :vendor_client_charts_quantity
    end
  end

  resources :external_bills do
    get :open, on: :member
    get :add_detail, on: :collection
    get :index_by_client, on: :collection
  end

  resources :external_arrivals do
    get :new_batch_detail, on: :collection
    get :open, on: :member
    get :index_by_file, on: :collection
    get :add_detail, on: :collection
    get :import, on: :collection
    get :new_stock, on: :collection
    post :create_stock, on: :collection
  end

  resources :external_shipments do
    get :new_batch_detail, on: :collection
    get :open, on: :member
    get :index_by_file, on: :collection
    get :add_detail, on: :collection
    get :import, on: :collection
    get :stock, on: :collection
    get :new_stock, on: :collection
    post :create_stock, on: :collection
  end

  resources :expedient_bills

  resources :supplier_tracings, only: :index
  scope module: :entities do
    scope module: :suppliers do
      resource :supplier_contacts do
        get :index_by_supplier, on: :collection
      end
      resources :suppliers do
        post :import, on: :collection
        get :index_by_company, on: :collection
				post :import, on: :collection

        resources :supplier_account_movements
        get :products, on: :member
        resources :supplier_contacts do
          resources :supplier_contact_records
        end
      end
    end
    scope module: :clients do
      resources :entity_banks
      resources :clients do
        get :index_by, on: :collection
				post :import, on: :collection
        get :debt, on: :member
        resources :client_account_movements
        resources :client_contacts do
          resources :client_contact_records
        end
      end
      resources :client_contacts do
        resources :client_contact_records, controller: :contact_records
      end
    end
  end



  scope module: :inventaries do
    resources :product_categories
    resources :products do
      get :filter_by_supplier, on: :collection
      get :filter_by_product, on: :collection
      get :filter_by_delivered_product, on: :collection
      post :import, on: :collection
      get :export, on: :collection
      get :valores_stock, on: :collection
      get :valores_stock_totales, on: :collection
      get :import_format, on: :collection
      get :index_by_company, on: :collection
      patch :fix_stock, on: :member
      get :new_clean_stock, on: :member
      post :clean_stock, on: :member
      resources :batches, only: [:index, :show, :destroy] do
        get :new_clean_stock, on: :member
        post :clean_stock, on: :member
        get :unit_gtins, on: :member
        get :availables, on: :collection
      end
    end
    resources :inventaries do
      get :sale_price_history, on: :member
      get :purchase_price_history, on: :member
      get :stock, on: :member
    end
    resources :boxes do
      get :search, on: :collection
    end
    resources :stores do
      get :products, on: :member
    end
  end

  resources :expedient_movements
  resources :expedient_receipts do
    get :open, on: :member
    get :assign_bill_to, on: :member
    post :import, on: :collection
  end

  namespace :agreement_surgeries do 
    resources :surgery_materials do
      get :index_by_company, on: :collection
      get :edit_update_prices, on: :collection
      post :update_prices, on: :collection
    end
    resources :price_updates
    resources :surgery_requests do
      member do 
        get :pre_rechazar
        patch :rechazar
        put :aprobar
        put :coordinar
        put :recuperar
        put :a_espera_procesamiento
        put :crear_expediente
      end
    end
    resources :files do
      get :index_by_company, on: :collection
      get :get_file_data, on: :member
    end
    resources :sale_orders do
      get :index_by_company, on: :collection
      get :open, on: :member
      get :deliver, on: :member
      get :get_details, on: :collection
    end
    resources :budgets  do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      get :deliver, on: :member
    end
    resources :shipments do
      get :new_batch_detail, on: :collection
      get :open, on: :member
      get :index_by_client, on: :collection
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :deliver, on: :member
      get :check_stock, on: :member
      get :get_details, on: :collection
      patch :conform, on: :member
    end
  end


  namespace :surgeries, path: 'surgeries' do
    resources :calendars, only: :index
    resources :excel_surgeries
    resources :files do
      get     :display_alerts, on: :member
      get     :show_alert, on: :member
      get     :new_alert, on: :member
      get     :edit_alert, on: :member
      patch   :update_alert, on: :member
      delete  :destroy_alert, on: :member
      post    :create_alert, on: :member
      get     :get_file_data, on: :member
      get     :index_by_client, on: :collection
      get     :index_by_company, on: :collection
      get     :vencidos, on: :collection
      put     :excluir_de_vencidos, on: :member
      get     :for_calendar, on: :collection
      get :new_cambiar_seller
      post :create_cambiar_seller
    end
    resources :arrivals do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :import, on: :collection
    end
    resources :prescriptions do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :index_by_client, on: :collection
      get :add_detail, on: :collection
    end

		resources :devolutions do
      get :new_batch_detail, on: :collection
			get :open, on: :member
      get :index_by_file, on: :collection
      get :index_by_supplier, on: :collection
      get :add_detail, on: :collection
    end
    resources :file_movements
    resources :supplier_requests do
      get :index_by_supplier, on: :collection
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
    end
    resources :purchase_requests do
      get :index_by_client, on: :collection
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
    end
    resources :purchase_orders  do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
			get :deliver, on: :member
    end
    resources :consumptions  do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :new_batch_detail, on: :collection
    end

    resources :shipments do
      get :new_batch_detail, on: :collection
      get :open, on: :member
      get :index_by_client, on: :collection
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :deliver, on: :member
      get :check_stock, on: :member
      get :get_details, on: :collection
      patch :conform, on: :member
    end

    resources :client_bills do
      get :associate_document, on: :collection
      get :open, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      get :set_manual, on: :member
    end

    resources :supplier_bills do
      get :open, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
    end

    resources :budgets  do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
			get :deliver, on: :member
    end

    resources :sale_orders do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      get :deliver, on: :member
      get :get_details, on: :collection
    end

    resources :receipts do
    end
  end

  namespace :purchases, path: 'purchases' do
    resources :files  do
      get     :show_alert, on: :member
      get     :new_alert, on: :member
      get     :edit_alert, on: :member
      patch   :update_alert, on: :member
      delete  :destroy_alert, on: :member
      post    :create_alert, on: :member
      get     :index_by_company, on: :collection
      get     :get_file_data, on: :member
    end
    resources :file_movements
    resources :purchase_requests do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :index_by_company, on: :collection
    end
    resources :orders do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :index_by_supplier, on: :collection
      get :add_detail, on: :collection
      get :index_by_company, on: :collection
      get :deliver, on: :member
    end
    resources :devolutions do
      get :new_batch_detail, on: :collection
      get :open, on: :member
      get :index_by_file, on: :collection
      get :set_params_delivery_note, on: :member
      post :create_deliver_note, on: :member
      get :add_detail, on: :collection
      get :index_by_company, on: :collection
    end
    resources :budgets do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :index_by_supplier, on: :collection
      get :add_detail, on: :collection
      get :index_by_company, on: :collection
    end
    resources :arrivals do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :get_gtins, on: :collection
      get :index_by_company, on: :collection
    end
    resources :bills do
      get :open, on: :member
      get :add_detail, on: :collection
      get :index_by_company, on: :collection
      get :index_by_supplier, on: :collection
      get :associate_document, on: :collection
    end
    resources :payment_orders do
      get :open, on: :member
      get :calendar, on: :collection
      post :import, on: :collection
    end
  end

  namespace :stores do
    resources :users, only: :index do
      get :new_invitation, on: :collection
      post :invite, on: :collection
    end
    resources :stocks, only: :index
    resources :stock_requests do
      patch :change_state, on: :member
    end
    resources :externals do
      get :available_store_lines, on: :member
      resources :store_lines, controller: "externals/store_lines"
      resources :store_activities, controller: "externals/store_activities"
    end
    resources :locals
  end

  resources :delivery_notes

  resources :permissions
  resources :purchase_file_movements
  resources :transfer_notes

  namespace :sales, path: 'sales' do
    resources :calendars, only: :index
    resources :files do
      get     :display_alerts, on: :member
      get     :show_alert, on: :member
      get     :new_alert, on: :member
      get     :edit_alert, on: :member
      patch   :update_alert, on: :member
      delete  :destroy_alert, on: :member
      post    :create_alert, on: :member
      get     :get_file_data, on: :member
      get     :index_by_company, on: :collection
      get     :for_calendar, on: :collection
    end
    resources :file_movements
    resources :sale_requests do
      get :open, on: :member
      get :index_by_client, on: :collection
      get :add_detail, on: :collection
      get :index_by_file, on: :collection
    end
    resources :budgets do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
			get :deliver, on: :member
    end
    resources :orders do
      get :open, on: :member
      get :index_by_client, on: :collection
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
			get :deliver, on: :member
    end
    resources :bills do
      get :open, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      get :associate_document, on: :collection
      get :set_manual, on: :member
      get :export, on: :member
      get :edit_sended_state, on: :member
    end
    resources :shipments do
      get :new_batch_detail, on: :collection
      get :open, on: :member
      get :new_from_bill, on: :collection
      get :deliver, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      patch :conform, on: :member
    end
    resources :receipts do
    end
    # resources :resumes do
    #
    # end
  end

  namespace :tenders, path: 'tenders' do
    resources :files do
      get     :display_alerts, on: :member
      get     :show_alert, on: :member
      get     :new_alert, on: :member
      get     :edit_alert, on: :member
      patch   :update_alert, on: :member
      delete  :destroy_alert, on: :member
      post    :create_alert, on: :member
      get     :get_file_data, on: :member
      get     :index_by_company, on: :collection
    end
    resources :file_movements
    resources :sale_requests do
      get :open, on: :member
      get :index_by_client, on: :collection
      get :add_detail, on: :collection
      get :index_by_file, on: :collection
    end
    resources :budgets do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
			get :deliver, on: :member
    end
    resources :supplier_budgets do
      get :open, on: :member
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
			get :deliver, on: :member
    end
    resources :orders do
      get :open, on: :member
      get :index_by_client, on: :collection
      get :index_by_file, on: :collection
      get :add_detail, on: :collection
      get :deliver, on: :member
    end
    resources :bills do
      get :open, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      get :set_manual, on: :member
    end

    resources :shipments do
      get :open, on: :member
      get :new_from_bill, on: :collection
      get :deliver, on: :member
      get :add_detail, on: :collection
      get :index_by_client, on: :collection
      patch :conform, on: :member
    end
    # resources :resumes do
    #
    # end
  end

    resources :activities, only: [:index, :show]
    resources :notifications, only: [:index, :show]
    resources :alerts
    resources :responsables
    resources :dolar_conversions do
      collection do
        get :conversion
        get :dolar_cotization
      end
    end

  resources :file_attributes_configs, except: :index

  scope module: :entity do
    resources :client_contacts do
      get :index_by_client, on: :collection
    end
  end

  # rutas de Ariel
  scope module: :finances do
    resources :bank_check_payments do
      patch :collect, on: :member
    end
    resources :promissory_note_payments do
      patch :collect, on: :member
    end
    resources :cash_account_logs
    resources :payment_types
    resources :checkbooks
    resources :emitted_checks
		resources :check_amends
    resources :incomes
    resources :expenses
    resources :imprest_clearings
    resources :bank_accounts do
      post :load_transactions, on: :member
      resources :bank_account_importer_configurations
    end
    resources :regular_cash_accounts do
    	resources :imprest_clearings do
        get :analyze, on: :member
        patch :confirm, on: :member
      end
    end
    resources :general_cash_accounts do
      member do
        get :print
      end
    end
    resources :cash_accounts do
      resources :initial_balances
      resources :general_cash_expenses
      resources :general_cash_incomes
      resources :cash_account_expenditures, only: [:new, :show, :create, :destroy]
    end
    resources :expense_details, only: [:show, :edit]
    resources :cash_solicitudes do
      member do
        get :analyze
        patch :evaluate
        get :complete
        patch :update_expenses
        get :refund
        patch :finalize
        get :print
      end
      collection do
        get :new_external
        post :create_external
        get :all
      end
      resources :cash_withdrawals
    end
    resources :promissory_payments, only: [:show, :index]
    resources :expenditures

  end
end
