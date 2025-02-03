# frozen_string_literal: true

module DatatableConstants
  module_function

  Ticket = {
    'id' => { name: "ID", source: "Ticket.id", cond: :eq },
    'title' => { name: "Titulo", source: "Ticket.title", cond: :like },
    'user' => {name: "Creado por", source: 'User.first_name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    'function_points' => { name: "Pts. función", source: "Ticket.function_points", cond: :eq},
    'created_at' => { name: "Generado", source: "Ticket.created_at", cond: :date_range, delimiter: '-yadcf_delim-' },
    'date' => { name: "Finalizado", source: "Ticket.date", cond: :date_range, delimiter: '-yadcf_delim-' },
    'priority' => { name: "Prioridad", source: "Ticket.priority", cond: :eq},
    'classification' => { name: "Tipo", source: "Ticket.classification", cond: :like},
    'area' => {name: "Area", source: "Ticket.area", cond: :like},
    'state' => { name: "Estado", source: "Ticket.state",
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tickets.state").matches(::Ticket.humanized_state(search))}},
  }

  BillMovement = {
    'id' => { name: "ID", source: "BillMovement.id", cond: :eq },
    'date' => { name: "Fecha", source: "BillMovement.date", cond: :date_range, delimiter: '-yadcf_delim-' },
    'bill_name' => { name: "Comprobante", source: "BillMovement.bill_name", cond: :like },
    'client' => { name: "Cliente", source: "BillMovement.client", cond: :like },
    'delivered_to' => { name: "Entregada a", source: "BillMovement.deliver_to", cond: :like },
    'signed' => { name: "¿Firmada?", source: "BillMovement.signed", searcheable: false },
    'returned' => { name: "Devolución", source: "BillMovement.returned", searcheable: false },
    'observation' => { name: "Observación", source: "BillMovement.observation", searcheable: false },
  }

  Notification = {
    'id' => { name: 'ID', source: 'Notification.id', cond: :eq },
    'title' => { name: 'Título', source: 'Notification.title', cond: :like },
    'date' => { name: "Fecha", source: 'Notification.created_at', cond: :date_range, delimiter: '-yadcf_delim-' },
    'seen' => { name: "Estado", source: 'Notification.seen', cond: :like}
  }

  Activity = {
    'id' => { name: 'ID', source: 'Activity.id', cond: :eq },
    'activity_type' => { name: 'Tipo', source: 'Activity.activity_type', cond: :like },
    'title' => { name: 'Título', source: 'Activity.title', cond: :like },
    'body' => { name: 'Cuerpo', source: 'Activity.body', cond: :like }
  }

  Attendance = {
    'id' => {name: "ID", source: "Attendance.id", cond: :eq},
    "present_icon" => {name: "Presente", source: "Attendance.present", cond: :eq},
    "date" => {name: "Fecha", source: "Attendance.date", cond: :date_range, delimiter: '-yadcf_delim-' },
    "check_in" => {name: "Check In", source: "Attendance.check_in", searcheable: false},
    "check_out" => {name: "Check Out", source: "Attendance.check_out", searcheable: false}
  }

  DayAttendance = {
    'id' => {name: "ID", source: "Attendance.id", cond: :eq},
    'user' => {name: "Empleado", source: 'User.first_name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    "date" => {name: "Fecha", source: "Attendance.date", cond: :date_range, delimiter: '-yadcf_delim-'},
    "check_in" => {name: "Check In", source: "Attendance.check_in", cond: :date_range, delimiter: '-yadcf_delim-'},
    "check_out" => {name: "Check Out", source: "Attendance.check_out", cond: :date_range, delimiter: '-yadcf_delim-'}
  }

  NonPresentUser ={
    'id' => {name: "ID", source: "NonPresentUser.id", cond: :eq},
    'user' => {name: "Empleado", source: 'User.first_name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    "date" => {name: "Fecha", source: "NonPresentUser.date", cond: :date_range, delimiter: '-yadcf_delim-' }
  }

  AttendanceResume = {
    'id' => { name: "ID", source: "AttendanceResume.id", cond: :eq},
    'month' => {name: "Mes", source: "AttendanceResume.month", cond: :eq},
    'year' => {name: "Año", source: "AttendanceResume.year", cond: :eq},
    'user_name' => {name: "Empleado", source: 'User.name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    'cumpliment' => {name: "Cumplimiento", source: "AttendanceResume.cumpliment", cond: :eq},
    'file_number' => {name: "Legajo", source: "User.file_number", cond: :eq},
    'machine_id' => {name: "ID biométrico", source: "User.machine_id", cond: :like},
    "work_station_name" => {name: "Puesto", source: "WorkStation.name", cond: :like}
  }.freeze

  AttendanceCategory = {
    'id' => {name: "ID", source: "AttendanceCategory.id", cond: :eq},
    'name' => {name: "Nombre", source: "AttendanceCategory.name", cond: :like},
    'work_days' => {name: "Días de trabajo", source: "AttendanceCategory.working_days", cond: :like},
    'check_in_label' => {name: "Entrada", source: "AttendanceCategory.check_in", cond: :like},
    'check_out_label' => {name: "Salida", source: "AttendanceCategory.check_out", cond: :like},
    'late_minutes' => {name: "Tolerancia", source: "AttendanceCategory.late", cond: :eq}
  }

  WorkStation = {
    'id' => {name: "ID", source: "WorkStation.id", cond: :eq},
    'name' => {name: "Nombre", source: "WorkStation.name", cond: :like},
    'responsable_name' => {name: "Encargado", source: "User.name", cond: :like},
    'users_quantity' => {name: "Cantidad de empleados", source: "WorkStation.users", cond: :eq}
  }

  ClientAccountMovement = {
    'id' => { name: 'ID', source: 'ClientAccountMovement.id', cond: :eq },
    'date' => { name: 'Fecha', source: 'AccountMovement.date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'cbte_tipo' => { name: 'Comprobante', source: 'ClientAccountMovement.cbte_tipo', cond: :like },
    'income' => { name: 'Debe', source: 'ClientAccountMovement.flow',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("account_movements.total").eq(search)
      }},
    'expense' => { name: 'Haber', source: 'ClientAccountMovement.flow',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("account_movements.total").eq(search)
      }},
    'balance' => { name: 'Balance', source: 'ClientAccountMovement.balance', cond: :like }
  }

  ClientDebt = {
    'id' => { name: 'ID', source: 'GeneralBill.id', cond: :eq },
    'cbte_tipo' => {name: 'Clase', source: "GeneralBill.cbte_tipo", cond: ->(column, search) {
      Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
    'sale_point' => {name: "Pto. vta", source: 'GeneralBill.sale_point', cond: :like},
    'number' => {name: "Factura", source: 'GeneralBill.number', cond: :like},
    'fch_vto_pago' => {name: "Vencimiento", source: 'GeneralBill.fch_vto_pago', cond: :date_range, delimiter: '-yadcf_delim-'},
    'total' => {name: "Total", source: 'GeneralBill.total', cond: :eq},
    'total_left' => {name: "Saldo", source: 'GeneralBill.total_left', cond: :eq},
    'pacient' => {name: "Afiliado", source: 'Expedient.custom_attributes',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")
        .or(Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient_number'").matches("%#{ search }%"))
      }},
    'external_file_number' => {name: "Exp. Ext.", source: 'Expedient.custom_attributes',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
    'external_purchase_order' => {name: "O.C.", source: 'Expedient.custom_attributes',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order'").matches("%#{ search }%")}},
  }

  EntityBank = {
    'id' => { name: 'ID', source: 'EntityBank.id', cond: :eq },
    'name' => { name: 'Banco', source: 'EntityBank.name', cond: :like },
    'branch_office' => { name: 'Sucursal', source: 'EntityBank.created_at', cond: :like },
    'cuit' => { name: 'C.U.I.T.', source: 'EntityBank.cuit', cond: :like },
    'denomination' => { name: 'Denominación', source: 'EntityBank.denomination', cond: :like }
  }

  Alert = {
    'id' => { name: 'ID', source: 'Alert.id', cond: :eq },
    'title' => { name: 'Titulo', source: 'Alert.title', cond: :like },
    'user' => { name: 'Creado por', source: 'Alert.user_name.', cond: :like },
    'init_date' => { name: 'Inicio', source: 'Alert.init_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'final_date' => { name: 'Fin', source: 'Alert.final_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'state' => { name: 'Estado',  source: 'Alert.state', cond: :like }
  }

  Client = {
    'id' => { name: 'ID', source: 'Client.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'Client.name', cond: :like },
    'denomination' => { name: 'Denominación', source: 'Client.denomination', cond: :like },
    'document' => { name: 'Documento', source: 'Client.document_number', cond: :like },
    'iva_cond' => { name: 'Condición I.V.A.',  source: 'Client.iva_cond', cond: :like },
    'current_balance' => { name: 'Balance ($)', source: 'Client.current_balance', cond: :eq }
  }

  SupplierContact = ClientContact = {
    'id' => { name: 'ID', source: 'EntityContact.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'EntityContact.name', cond: :like },
    'position' => { name: 'Cargo', source: 'EntityContact.position', cond: :like },
    'email' => { name: 'Email', source: 'EntityContact.email', cond: :like },
    'phone' => { name: 'Teléfono', source: 'EntityContact.phone', cond: :like },
    'mobile_phone' => { name: 'Celular', source: 'EntityContact.mobile_phone', cond: :like },
    'titular' => { name: 'Tipo',  source: 'EntityContact.titular', cond: :like }
  }

  SupplierContactRecord = ClientContactRecord = {
    'id' => { name: 'ID', source: 'EntityRecord.id', cond: :eq },
    'date' => { name: 'Fecha', source: 'EntityRecord.date', cond: :like },
    'title' => { name: 'Título', source: 'EntityRecord.title', cond: :like },
    'object' => { name: 'Objeto', source: 'EntityRecord.object', cond: :like },
    'user_name' => { name: 'Generado por', source: 'User.name', cond: :like },
    'created_at' => { name: 'Registrado en', source: 'EntityRecord.created_at', cond: :date_range, delimiter: '-yadcf_delim-' }
  }

  CHECKBOOK = {
    'id' => { name: 'ID', source: 'Checkbook.id', cond: :eq },
    'number' => { name: 'Numero', source: 'Checkbook.number', cond: :like },
    'init_number' => { name: 'Numeración inicial', source: 'Checkbook.init_number', cond: :like },
    'final_number' => { name: 'Numeración final', source: 'Checkbook.final_number', cond: :like },
    'bank' => { name: 'Banco', source: 'Bank.name', cond: :like }
  }

  BATCH = Batch = {
    'id' => { name: 'ID', source: 'Batch.id', cond: :eq },
    'code' => { name: 'Lote', source: 'Batch.code', cond: :like },
    'serial' => { name: 'Serie', source: 'Batch.serial', cond: :like },
    'quantity' => { name: 'Disponible', source: 'Batch.quantity', cond: :like },
    'state' => { name: 'Estado', source: 'Batch.state', cond: :like},
    'due_date' => { name: 'Vto', source: 'Batch.due_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'batch_stores' => { name: 'Depositos', source: 'Batch.state'},
  }

  PRODUCT_CATEGORY = ProductCategory = {
    'id' => { name: 'ID', source: 'ProductCategory.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'ProductCategory.name', cond: :like },
    'default_iva' => { name: 'I.V.A.', source: 'ProductCategory.default_iva', cond: :eq },
    'products_count' => { name: 'Cantidad de productos', source: 'ProductCategory.products_count', cond: :eq }
  }

  Supplier = {
    'id' => { name: 'ID', source: 'Entity.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'Entity.name', cond: :like },
    'denomination' => { name: 'Denominación', source: 'Client.denomination', cond: :like },
    'document_number' => { name: 'Documento', source: 'Entity.document_number', cond: :like },
    'contact_name' => { name: 'Contacto primario', source: 'SupplierContact.name', cond: :like },
    'contact_phone' => { name: 'Teléfono primario', source: 'SupplierContact.phone', cond: :like },
    'contact_email' => { name: 'Email primario', source: 'SupplierContact.email', cond: :like },
    'current_balance' => { name: 'Balance ($)', source: 'Supplier.current_balance', cond: :eq }
  }

  SupplierAccountMovement = {
    'id' => { name: 'ID', source: 'SupplierAccountMovement.id', cond: :eq },
    'date' => { name: 'Fecha', source: 'SupplierAccountMovement.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'cbte_tipo' => { name: 'Comprobante', source: 'SupplierAccountMovement.cbte_tipo', cond: :like },
    'income' => { name: 'Debe', source: 'SupplierAccountMovement.flow', cond: :eq },
    'expense' => { name: 'Haber', source: 'SupplierAccountMovement.flow', cond: :eq }
  }

  SUPPLIER_CONTACT = {
    'id' => { name: 'ID', source: 'SupplierContact.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'SupplierContact.name', cond: :like },
    'position' => { name: 'Cargo', source: 'SupplierContact.position', cond: :like },
    'email' => { name: 'Email', source: 'SupplierContact.email', cond: :like },
    'phone' => { name: 'Teléfono', source: 'SupplierContact.phone', cond: :like },
    'mobile_phone' => { name: 'Celular', source: 'SupplierContact.mobile_phone', cond: :like },
    'titular' => { name: 'Tipo', source: 'SupplierContact.position', cond: :like }
  }

  SALE_FILE = {
    'id' => { name: 'ID', source: 'Expedient.id', cond: :eq },
    'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
    'title' => { name: 'Título', source: 'Expedient.title', cond: :like },
    'client' => { name: 'Cliente', source: 'Entity.name', cond: :like },
    'sellers' => { name: "Vendedores", source: 'User.first_name', orderable: false,
                  cond: ->(column, search) {
                    Arel::Nodes::SqlLiteral.new("UPPER(sellers.first_name || ' ' || sellers.last_name)").matches("%#{ search.upcase }%")}},
    'responsable' => {name: "Responsable", source: 'User.first_name',
                  cond: ->(column, search) {
                    Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
    'sale_type' => { name: 'Tipo', source: 'Expedient.sale_type', cond: :like },
    'created_at' => { name: 'Creación', source: 'Expedient.created_at', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'finish_date' => { name: 'Vencimiento', source: 'Expedient.finish_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'substate' => { name: 'Estado', source: 'Expedient.substate', cond: :like }
  }

  SALE_REQUEST = {
    'id' => { name: 'ID', source: 'ExpedientRequest.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientRequest.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'init_date' => { name: 'Fecha de inicio', source: 'ExpedientRequest.init_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'final_date' => { name: 'Fecha de vencimiento', source: 'ExpedientRequest.final_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'urgency' => { name: 'Urgencia',  source: 'ExpedientRequest.urgency', searcheable: false },
    'state' => { name: 'Estado',  source: 'ExpedientRequest.state', cond: :like }
  }

  SALE_BUDGET = {
    'id' => { name: 'ID', source: 'ExpedientBudget.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientBudget.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'init_date' => { name: 'Fecha de inicio', source: 'ExpedientBudget.init_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'final_date' => { name: 'Fecha de vencimiento', source: 'ExpedientBudget.final_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'total' => { name: 'Total', source: 'ExpedientBudget.total', cond: :eq },
    'state' => { name: 'Estado', source: 'ExpedientBudget.state', cond: :like }
  }

  SALE_ORDER = {
    'id' => { name: 'ID', source: 'ExpedientOrder.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientOrder.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'expected_delivery_date' => { name: 'Fecha de llegada', source: 'ExpedientOrder.expected_delivery_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'total' => { name: 'Total', source: 'ExpedientOrder.total', cond: :eq },
    'state' => { name: 'Estado', source: 'ExpedientOrder.state', cond: :like }
  }

  SALE_BILL = {
    'id' => { name: 'ID', source: 'ExpedientBill.id', cond: :eq },
    'cbte_tipo' => { name: 'Tipo', source: 'ExpedientBill.cbte_tipo', cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
    'number' => { name: 'Número', source: 'ExpedientBill.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'sellers' => {name: "Vendedor", source: 'User.first_name',
                  cond: ->(column, search) {
                    Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
    'credits' => {name: "Creditos ($)", source: 'ExpedientBill.total', searcheable: false},
    'debits' => {name: "Debitos ($)", source: 'ExpedientBill.total', searcheable: false},
    'total_paid' => {name: "Pagado ($)", source: 'ExpedientBill.total_pay', cond: :eq},
    'total' => { name: 'Total ($)', source: 'ExpedientBill.total', cond: :eq },
    'paid' => { name: '¿Pagado?', source: 'ExpedientBill.total_left', searcheable: false },
    'state' => { name: 'Estado', source: 'ExpedientBill.state', cond: :like },
    'estimated_days_to_pay' => { name: 'Pago', source: 'ExpedientBill.estimated_days_to_pay', cond: :eq }
  }

  SALE_SHIPMENT = {
    'id' => { name: 'ID', source: 'ExpedientShipment.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientShipment.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'date' => { name: 'Fecha', source: 'ExpedientShipment.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'tipo' => { name: 'Tipo', source: 'ExpedientShipment.shipment_type', cond: :like },
    'state' => { name: 'Estado', source: 'ExpedientShipment.state', cond: :like }
  }

  ExpedientReceipt = {
    'id' => { name: 'ID', source: 'ExpedientReceipt.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientReceipt.number', cond: :like },
    'client' => { name: 'Cliente', source: 'Client.name', cond: :like },
    'client_payment_order' => { name: 'Orden de pago', source: 'ExpedientReceipt.client_payment_order', cond: :like },
    'date' => { name: 'Fecha', source: 'ExpedientReceipt.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'total' => { name: 'Total', source: 'ExpedientReceipt.total', cond: :eq },
    'state' => { name: 'Estado', source: 'ExpedientReceipt.state', cond: :like }
  }

  SALE_RESUME = {
    'id' => { name: 'ID', source: 'SaleResume.id', cond: :eq },
    'month' => { name: 'Mes', source: 'SaleResume.month', cond: :eq },
    'year' => { name: 'Year', source: 'SaleResume.year', cond: :eq },
    'total_bills' => { name: 'Total a cobrar', source: 'SaleResume.total_bills', cond: :eq },
    'balance' => { name: 'Balance', source: 'SaleResume.balance', cond: :eq },
    'total_payed' => { name: 'Total cobrado', source: 'SaleResume.total_payed', cond: :eq },
    'last_update' => { name: 'Ultima actualización', source: 'SaleResume.last_update', cond: :like }
  }

  FILE_MOVEMENT = {
    'id' => { name: 'ID',  source: 'ExpedientMovement.id', cond: :eq },
    'sended_by' => { name: 'Enviado por', source: 'ExpedientMovement.sended_by', cond: :like },
    'department' => { name: 'Enviado a',  source: 'ExpedientMovement.department', cond: :like },
    'received_by' => { name: 'Recibido por', source: 'ExpedientMovement.received_by', cond: :like },
    'sended_at' => { name: 'Fecha', source: 'ExpedientMovement.sended_at', cond: :date_range, delimiter: '-yadcf_delim-'  }
  }

  PURCHASE_REQUEST = {
    'id' => { name: 'ID', source: 'ExpedientRequest.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientRequest.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'init_date' => { name: 'Fecha de inicio', source: 'ExpedientRequest.init_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'final_date' => { name: 'Fecha de vencimiento', source: 'ExpedientRequest.final_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'urgency' => { name: 'Urgencia', source: 'ExpedientRequest.urgency', searcheable: false },
    'request_type' => { name: 'Tipo', source: 'ExpedientRequest.request_type', cond: :like },
    'state' => { name: 'Estado', source: 'ExpedientRequest.state', cond: :like }
  }

  PURCHASE_BUDGET = {
    'id' => { name: 'ID', source: 'ExpedientBudget.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientBudget.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
    'init_date' => { name: 'Fecha de inicio', source: 'ExpedientBudget.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'final_date' => { name: 'Fecha de vencimiento', source: 'ExpedientBudget.due_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'delivery_date' => { name: 'Entrega', source: 'ExpedientBudget.delivery_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'total' => { name: 'Total', source: 'ExpedientBudget.total', cond: :eq },
    'state' => { name: 'Estado',  source: 'ExpedientBudget.state', cond: :like }
  }

  PURCHASE_ORDER = {
    'id' => { name: 'ID', source: 'ExpedientOrder.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientOrder.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'supplier' => { name: 'Proveedor', source: 'Supplier.name', cond: :like },
    'file_created_at' => { name: 'Creado en', source: 'ExpedientOrder.created_at', cond: :eq, delimiter: '-yadcf_delim-' },
    'paid' => { name: '¿Pagado?', source: 'ExpedientOrder.paid', searcheable: false },
    'shipping_included' => { name: 'Envio', source: 'ExpedientOrder.shipping_included', cond: :eq },
    'expected_delivery_date' => { name: 'Fecha de llegada', source: 'ExpedientOrder.expected_delivery_date', cond: :eq },
    'paid' => { name: '¿Pagado?', source: 'ExpedientOrder.paid', cond: :eq },
    'total' => { name: 'Total', source: 'ExpedientOrder.total', cond: :eq },
    'state' => { name: 'Estado', source: 'ExpedientOrder.state', cond: :like }
  }

  ExternalArrival= PURCHASE_ARRIVAL = {
    'id' => { name: 'ID', source: 'ExpedientArrival.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientArrival.number', cond: :like },
    'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
    'date' => { name: 'Fecha', source: 'ExpedientArrival.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'punctuation' => { name: 'Puntuación', source: 'ExpedientArrival.punctuation', cond: :eq },
    'state' => { name: 'Estado', source: 'ExpedientArrival.state', cond: :like }
  }

  ExternalShipment = SALE_SHIPMENT

  ExternalShipmentStock = {
    'date' => { name: 'Fecha', source: 'ExpedientShipment.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'salida' => { name: 'Número', source: 'ExpedientShipment.number', cond: :like },
    'state' => { name: 'Estado', source: 'ExpedientShipment.state', cond: :like },
    'store' => { name: 'Deposito', source: 'ExpedientShipment.store', cond: :like },
    'salida_productos' => { name: 'Salida Productos', source: 'ExpedientArrival.id', cond: :like },
    'entrada_productos' => { name: 'Salida Productos', source: 'ExpedientArrival.id', cond: :like },
    'deposito_entrada' => { name: 'Deposito entrada', source: 'ExpedientArrival.id', cond: :like },
    'estado_entrada' => { name: 'Deposito entrada', source: 'ExpedientArrival.id', cond: :like },
    'entrada' => { name: 'Entrada', source: 'ExpedientArrival.id', cond: :like },
    'fecha_entrada' => { name: 'Fecha entrada', source: 'ExpedientArrival.id', cond: :like },
  }
  

  ExternalBill = PURCHASE_BILL = {
    'id' => { name: 'ID', source: 'ExpedientBill.id', cond: :eq },
    'cbte_tipo' => { name: 'Tipo', source: 'ExpedientBill.cbte_tipo', cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
    'number' => { name: 'Número', source: 'ExpedientBill.number', cond: :like },
    'supplier' => { name: 'Proveedor', source: 'Supplier.name', cond: :like },
    'credits' => {name: "Creditos ($)", source: 'ExpedientBill.total', searcheable: false},
    'debits' => {name: "Debitos ($)", source: 'ExpedientBill.total', searcheable: false},
    'total_paid' => {name: "Pagado ($)", source: 'ExpedientBill.total_pay', cond: :like},
    'total' => { name: 'Total ($)', source: 'ExpedientBill.total', cond: :like },
    'paid' => { name: '¿Pagado?', source: 'ExpedientBill.total_left', searcheable: false },
    'state' => { name: 'Estado', source: 'ExpedientBill.state', cond: :like }
  }

  PURCHASE_RETURN = {
    'id' => { name: 'ID', source: 'ExpedientDevolution.id', cond: :eq },
    'number' => { name: 'Número', source: 'ExpedientDevolution.number', cond: :like },
    'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
    'supplier' => { name: 'Proveedor', source: 'Supplier.name', cond: :like },
    'date' => { name: 'Fecha de devolución', source: 'ExpedientDevolution.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'state' => { name: 'Estado', source: 'ExpedientDevolution.state', cond: :like }
  }

  UserVacation = {
    'id' => {name: "ID", source: "UserVacation.id", cond: :eq},
    'user_name' => {name: "Empleado", source: 'User.name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    'init_date_label' => {name: "Fecha inicial", source: 'UserVacation.init_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'final_date_label' => {name: "Fecha final", source: 'UserVacation.final_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'days' => {name: "Días", source: "UserVacation.days", cond: :eq},
    'approved_icon' => {name: "Aprobadas?", source: "UserVacation.approved", cond: :eq}
  }

  Permission = {
    'id' => {name: "ID", source: "Permission.id", cond: :eq},
    'user_name' => {name: "Empleado", source: 'User.name',
      cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
      }},
    'init_date_label' => {name: "Fecha inicial", source: 'Permission.init_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'final_date_label' => {name: "Fecha final", source: 'Permission.final_date', cond: :date_range, delimiter: '-yadcf_delim-' },
    'days' => {name: "Días", source: "Permission.days", cond: :eq},
    'approved_icon' => {name: "Aprobadas?", source: "Permission.approved", cond: :eq}
  }

  User = {
    'id' => {name: "ID", source: "User.id", cond: :eq},
    'first_name' => {name: "Nombre", source: "User.first_name", cond: :like},
    'last_name' => {name: "Apellido", source: "User.last_name", cond: :like},
    'email' => {name: "Email", source: "User.email", cond: :like},
    'document_number' => {name: "DNI/CUIL", source: "User.document_number", cond: :like},
    'file_number' => {name: "Legajo", source: "User.file_number", cond: :like},
    'work_station_name' => {name: "Puesto", source: "WorkStation.name", cond: :like},
    'start_of_activity' => {name: "Inicio de actividad", source: "User.start_of_activity", cond: :date_range, delimiter: '-yadcf_delim-' },
    'birthday' => {name: "Nacimiento", source: "User.birthday", cond: :date_range, delimiter: '-yadcf_delim-' },
    'address' => {name: "Dirección", source: "User.birthday", cond: :like},
    'status' => {name: "Estado", source: "User.status", searcheable: false}
  }

  UserRole = {
    "id" 			=> {name: "ID", source: "UserRole.id", cond: :eq},
    "role_name" 			=> {name: "Rol", source: "Role.friendly_name", cond: :like}
  }

  Role = {
    "id" 			  => {name: "ID", source: "Role.id", cond: :eq},
    "role_name" => {name: "Nombre", source: "Role.name", cond: :like}
  }


  Responsable = {
    "id"            => {name: "ID", source: "Responsable.id", cond: :eq},
    "file_type"     => {name: "Tipo de expediente", source: "Expedient.type", cond: :like},
    "file_number"   => {name: "Expediente", source: "Expedient.number", cond: :like},
    "document_type" => {name: "Documento asignado", source: "Responsable.document_type", cond: :like},
    "observation"   => {name: "Observación", source: "Responsable.observation", cond: :like},
    "created_at"    => {name: "Fecha de delegación", source: "Responsable.created_at", cond: :date_range, delimiter: '-yadcf_delim-' }
  }

  ExpedientMovement = FILE_MOVEMENT

  CashAccountLog = Income = Expense = {
    'id'    => {name: "#", source: "CashAccountLog.id", cond: :like},
    'codigo' => {name: "Comp", source: "CashAccountLog.codigo", cond: :like},
    'entidad' => {name: "ID", source: "CashAccountLog.entidad", cond: :like},
    'date' => {name: "Fecha", source: "CashAccountLog.date", cond: :date_range, delimiter: '-yadcf_delim-' },
    'description' => {name: "Descripción", source: "CashAccountLog.description", cond: :like},
    'monto' => {name: "Monto", source: "CashAccountLog.monto", cond: :eq},
    'forma' => {name: "Forma", source: "CashAccountLog.forma", cond: :like},
  }

  PromissoryPayment = {
    'numero_cheque' => {name: "Numero", source: "PromissoryPayment.numero_cheque", cond: :like},
    'receipt' => {name: "Recibo", source: "ExpedientReceipt.number", cond: :like},
    'client' => {name: "Cliente", source: "Entity.name", cond: :like },
    'vencimiento' => {name: "Vencimiento", source: "PromissoryPayment.vencimiento", cond: :date_range, delimiter: '-yadcf_delim-'},
    'dias' => {name: "Días", source: "PromissoryPayment.vencimiento", searcheable: false},
    'importe' => {name: "Importe", source: "PromissoryPayment.importe", cond: :eq},
  }

  ImprestSystem = {
    'id' => { name: 'ID', source: 'ImprestSystem.id', cond: :eq },
    'nombre_descriptivo' => { name: 'Nombre descriptivo', source: 'ImprestSystem.nombre_descriptivo', cond: :like },
    'user' => { name: 'Responsable', source: 'User.name', cond: :like },
    'sale_point_number' => { name: 'Punto de venta', source: 'SalePoint.number', cond: :like },
    'fondo_fijo' => { name: 'Fondo fijo',  source: 'ImprestSystem.fondo_fijo', cond: :eq },
    'limite_max' => { name: 'Límite máximo', source: 'ImprestSystem.limite_max', cond: :eq }
  }

  ImprestClearing = {
    'id' => { name: 'Número', source: 'ImprestClearing.id', cond: :eq },
    'fecha' => { name: 'Fecha', source: 'ImprestClearing.fecha', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'regular_cash_account' => { name: 'Caja origen', source: 'RegularCashAccount.nombre', cond: :like },
    'user' => { name: 'Persona', source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
    'fondo_fijo' => { name: 'Fondo fijo', source: 'ImprestClearing.fondo_fijo', cond: :eq },
    'saldo_inicio' => { name: 'Saldo de inicio', source: 'ImprestClearing.saldo_inicio', cond: :eq },
    'a_rendir' => { name: 'A rendir', source: 'ImprestClearing.a_rendir', cond: :eq },
    'saldo_en_caja' => { name: 'Saldo en caja', source: 'ImprestClearing.saldo_en_caja', cond: :eq },
  }


  # CashSolicitude = {
  #   'codigo' => { name: 'Código', source: 'CashSolicitude.codigo', cond: :like },
  #   'fecha' => { name: 'Fecha', source: 'CashSolicitude.fecha', cond: :date_range, delimiter: '-yadcf_delim-'  },
  #   'user' => { name: 'Persona', source: 'User.first_name',
  #                   cond: ->(column, search) {
  #                     Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
  #   'motivo' => { name: 'Motivo', source: 'CashSolicitude.motivo', cond: :like },
  #   'retiro' => { name: 'Retiro', source: 'CashWithdrawal.fecha', cond: :date_range, delimiter: '-yadcf_delim-'  },
  #   'importe' => { name: 'Importe', source: 'CashWithdrawal.importe', cond: :eq },
  #   'vuelto' => { name: 'Vuelto', source: 'CashSolicitude.created_at', searcheable:  false  },
  # }

  PaymentType = {
    'id' => {name: "ID", source: 'PaymentType.id', cond: :eq},
    'name' => {name: "Nombre", source: 'PaymentType.name', cond: :like},
    'imputed_in_cash' => {name: "¿Impacta en caja?", source: 'PaymentType.imputed_in_cash', searcheable: false},
  }

  EmittedCheck = {
    'numero' => {name: "Número", source: 'EmittedCheck.numero', cond: :eq},
    'estado' => { name: "Estado", source: 'EmittedCheck.estado', cond: :like },
    'vencimiento' => {name: "Vencimiento", source: 'EmittedCheck.vencimiento', cond: :date_range, delimiter: '-yadcf_delim-' },
    'orden_pago' => { name: "O.P.", source: 'Purchases::PaymentOrder', cond: :eq },
    'chequera' => {name: "Chequera", source: 'Checkbook.number', cond: :eq},
    'banco' => {name: "Banco", source: 'Bank.name', cond: :like},
    'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
    'importe' => {name: "Importe", source: 'EmittedCheck.importe', cond: :eq},
    'importe_pagado' => {name: "Pagos", source: 'EmittedCheck.importe_pagado', cond: :eq},
    'saldo' => {name: "Saldo", source: 'EmittedCheck.saldo', cond: :eq},
  }

  CashAccountExpenditure = {
    'codigo_recibo' => {name: "Recibo", source: 'Expenditure.numero_de_recibo', cond: :like},
    'comprobante' => {name: "Comprobante", source: 'Expenditure.num_comprobante', cond: :eq},
    'fecha' => {name: "Fecha", source: 'Expenditure.fecha', cond: :date_range, delimiter: '-yadcf_delim-' },
    'descripcion' => {name: "Recibo", source: 'Expenditure.descripcion', cond: :like},
    'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
    'order' => {name: "Documento", source: 'ExpedientOrder.number', cond: :like},
    'importe_neto' => {name: "Imp. Neto", source: 'Expenditure.total', cond: :eq},
  }

  # Expenditure = {
  #   'codigo_recibo' => {name: "Recibo", source: 'Expenditure.numero_de_recibo', cond: :like},
  #   'comprobante' => {name: "Comprobante", source: 'Expenditure.num_comprobante', cond: :eq},
  #   'fecha' => {name: "Fecha", source: 'Expenditure.fecha', cond: :date_range, delimiter: '-yadcf_delim-' },
  #   'descripcion' => {name: "Recibo", source: 'Expenditure.descripcion', cond: :like},
  #   'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
  #   'order' => {name: "Documento", source: 'ExpedientOrder.number', cond: :like},
  #   'importe_neto' => {name: "Imp. Neto", source: 'Expenditure.total', cond: :eq},
  # }


  Expenditure = {
    'comprobante' => {name: "Comprobante", source: 'Expenditure.num_comprobante', cond: :eq},
    'fecha' => {name: "Fecha", source: 'Expenditure.fecha', cond: :date_range, delimiter: '-yadcf_delim-' },
    'fecha_registro' => {name: "Registro", source: 'Expenditure.fecha_registro', cond: :date_range, delimiter: '-yadcf_delim-' },
    'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
    'importe_neto' => {name: "Imp. Neto", source: 'Expenditure.importe_neto', cond: :eq},
  }


  module Sales
    File            = SALE_FILE
    SaleRequest     = SALE_REQUEST.reject{|a| a if a == "request_type"}
    Budget          = SALE_BUDGET
    Order           = SALE_ORDER
    Shipment        = SALE_SHIPMENT
    Bill            = SALE_BILL
    FileMovement    = ExpedientMovement = FILE_MOVEMENT
    Receipt         = ExpedientReceipt
  end

  module Tenders
    File            = SALE_FILE
    Budget          = SALE_BUDGET
    Order           = SALE_ORDER
    Shipment        = SALE_SHIPMENT
    Bill            = SALE_BILL
    SaleRequest     = SALE_REQUEST
    SupplierBudget  = SALE_BUDGET
    FileMovement    = ExpedientMovement = FILE_MOVEMENT
  end

  Role = {
    'id' => { name: 'ID', source: 'Role.id', cond: :eq },
    'name' => { name: 'Nombre', source: 'Role.name', cond: :like }
  }

  module AgreementSurgeries
    SurgeryRequest = {
      'id' => { name: 'ID', source: 'AgreementSurgeries::SurgeryRequest.id', cond: :eq },
      'number' => { name: 'Número', source: 'AgreementSurgeries::SurgeryRequest.number', cond: :like },
      'document_number' => { name: 'DNI', source: 'AgreementSurgeries::SurgeryRequest.document_number', cond: :like },
      'first_name' => { name: 'Nombres', source: 'AgreementSurgeries::SurgeryRequest.first_name', cond: :like },
      'last_name' => { name: 'Apellidos', source: 'AgreementSurgeries::SurgeryRequest.last_name', cond: :like },
      'state' => { name: 'Estado', source: 'AgreementSurgeries::SurgeryRequest.aasm_state', cond: :like },
      'surgery_time' => { name: 'Tipo', source: 'AgreementSurgeries::SurgeryRequest.surgery_time', cond: :like },
      'created_by' => { name: 'Creado por', source: 'User.email', cond: :like },
      'created_at' => { name: 'Creado', source: 'AgreementSurgeries::SurgeryRequest.created_at', cond: :like },
    }

    SurgeryMaterial = {
      'id' => { name: 'ID', source: 'AgreementSurgeries::SurgeryMaterial.id', cond: :eq },
      'code' => { name: 'Codigo', source: 'AgreementSurgeries::SurgeryMaterial.code', cond: :like },
      'description' => { name: 'Descripcion', source: 'AgreementSurgeries::SurgeryMaterial.description', cond: :like },
      'category' => { name: 'Categoria', source: 'AgreementSurgeries::SurgeryMaterial.category', cond: :like },
      'price' => { name: 'Precio', source: 'AgreementSurgeries::SurgeryMaterial.price', cond: :like },
      'minimum_price' => { name: 'Precio Minimo', source: 'AgreementSurgeries::SurgeryMaterial.minimum_price', cond: :like },
      'maximum_price' => { name: 'Precio Maximo', source: 'AgreementSurgeries::SurgeryMaterial.maximum_price', cond: :like },
      'origin' => { name: 'Origen', source: 'AgreementSurgeries::SurgeryMaterial.origin', cond: :like },
      'user' => { name: 'Cargado por', source: 'User.email', cond: :like },
    }

    PriceUpdate = {
      'id' => { name: 'ID', source: 'AgreementSurgeries::PriceUpdate.id', cond: :eq },
      'created_at' => { name: 'Creado', source: 'AgreementSurgeries::PriceUpdate.created_at', cond: :like },
      'percent' => { name: 'Porcentaje', source: 'AgreementSurgeries::PriceUpdate.percent', cond: :like },
      'user' => { name: 'Cargado por', source: 'User.email', cond: :like },
    }

    File = {
      'id' => { name: 'ID', source: 'AgreementSurgeries::File.id', cond: :eq },
      'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
      'title' => { name: 'Título', source: 'Expedient.title', cond: :like },
      'created_at' => { name: 'Creado', source: 'AgreementSurgeries::File.created_at', cond: :like },
      'user' => { name: 'Cargado por', source: 'User.email', cond: :like },
      'responsable' => {
        name: "Responsable", 
        source: 'User.first_name',
        cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}
        },
      'substate' => { name: 'Estado', source: 'AgreementSurgeries::File.substate', cond: :like },
      'surgery_request' => { name: 'Solicitud', source: 'AgreementSurgeries::SurgeryRequest.number', cond: :like },
    }

    SaleOrder = SALE_ORDER.merge('social_work' => { name: 'Obra Social', source: 'AgreementSurgeries::File.social_work', cond: :like })
    Shipment = SALE_SHIPMENT.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
  end

  module Surgeries
    File            = {
                        'id' => { name: 'ID', source: 'Expedient.id', cond: :eq },
                        'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
                        'title' => { name: 'Título', source: 'Expedient.title', cond: :like },
                        'client' => { name: 'Obra Social', source: 'Entity.name', cond: :like },
                        'pacient_with_number' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                          cond: ->(column, search) {
                            Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")
                            .or(Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient_number'").matches("%#{ search }%"))
                          }},
                        'sellers' => { name: "Vendedores", source: 'User.first_name', orderable: false,
                                      cond: ->(column, search) {
                                        Arel::Nodes::SqlLiteral.new("UPPER(sellers.first_name || ' ' || sellers.last_name)").matches("%#{ search.upcase }%")}},
                        'responsable' => {name: "Responsable", source: 'User.first_name',
                                      cond: ->(column, search) {
                                        Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
                        'sale_type' => { name: 'Tipo', source: 'Expedient.sale_type', cond: :eq },
                        'created_at' => { name: 'Creación', source: 'Expedient.created_at', cond: :eq },
                        'finish_date' => { name: 'Vencimiento', source: 'Expedient.finish_date', cond: :date_range, delimiter: '-yadcf_delim-' },
                        'substate' => { name: 'Estado', source: 'Expedient.substate', cond: :like }
                      }
    FileVencidos = {
      'id' => { name: 'ID', source: 'Expedient.id', cond: :eq },
      'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
      'expedient_title' => { name: 'Titulo', source: 'Expedient.title', cond: :like },
      'expedient_state' => { name: 'Estado', source: 'Expedient.state', cond: :like },
      'seller' => { name: 'Vendedor', source: 'User.first_name', cond: :like },
      'place' => { name: "Lugar", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'place'").matches("%#{ search }%")}},
      'sale_order_date' => { name: 'Date', source: 'SaleOrder.expected_delivery_date', cond: :eq },
      'surgical_sheet' => { name: "Foja Quirúrgica", source: "Expedient.surgical_sheet_original_filename", searcheable: false, orderable: false},
      'implant_certificate' => { name: "Foja Quirúrgica", source: "Expedient.implant_certificate_original_filename", searcheable: false, orderable: false},
      'vencido' => { name: "Vencido", source: "Expedient.id", searcheable: false, orderable: false},
    }
    Prescription    = SALE_REQUEST.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    Budget          = SALE_BUDGET.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    SaleOrder       = SALE_ORDER.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    PurchaseRequest = PURCHASE_REQUEST.merge('pacient' => { name: 'Paciente', source: 'SurgeryRequest.custom_attributes', cond: ->(column, search) {
                        Arel::Nodes::SqlLiteral.new("requests.custom_attributes -> 'pacient'").matches("%#{ search }%")
                        .or(Arel::Nodes::SqlLiteral.new("requests.custom_attributes -> 'pacient_number'").matches("%#{ search }%"))
                      }})
    SupplierRequest = {
                      'id' => { name: 'ID', source: 'ExpedientRequest.id', cond: :eq },
                      'number' => { name: 'Número', source: 'ExpedientRequest.number', cond: :like },
                      'date' => { name: "Fecha", source: "ExpedientShipment.date", cond: :date_range, delimiter: '-yadcf_delim-'},
                      'entity' => { name: "Proveedor", source: "Entity.name", cond: :like},
                      'pacient' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                                    cond: ->(column, search) {
                                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
                      'external_file_number' => {name: "Exp. Ext.", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
                      'state' => { name: "Estado", source: "ExpedientShipment.state", cond: :like},
                      'user' => {name: "Usuario", source: 'User.name',
                        cond: ->(column, search) {
                          Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
                        }},
                      'observation' => { name: "Detalle", source: "ExpedientShipment.observation", cond: :string_in},
                      'file' => {name: "Exp. Int", source: "Expedient.title", cond: :like},
                      'sale_type' => {name: "Tipo", source: "Expedient.sale_type", cond: :like},
                      'external_purchase_order' => {name: "O.C.", source: 'Expedient.custom_attributes',
                        cond: ->(column, search) {
                          Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order'").matches("%#{ search }%")}},
                    }
    Arrival         = PURCHASE_ARRIVAL
    Shipment        = SALE_SHIPMENT.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    Consumption     = SALE_SHIPMENT.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    PurchaseOrder   = PURCHASE_ORDER
    SupplierBill    = PURCHASE_BILL.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    ClientBill      = SALE_BILL.merge('client' => { name: 'Obra Social', source: 'Client.name', cond: :like })
    FileMovement    = ExpedientMovement = FILE_MOVEMENT
    Devolution = {
      'id' => { name: 'ID', source: 'ExpedientDevolution.id', cond: :eq },
      'number' => { name: 'Número', source: 'ExpedientDevolution.number', cond: :like },
      'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'date' => { name: 'Fecha de devolución', source: 'ExpedientDevolution.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'state' => { name: 'Estado', source: 'ExpedientDevolution.state', cond: :like }
    }
    Receipt = ExpedientReceipt
  end

  module Purchases
    File = {
      'id' => { name: 'ID', source: 'Expedient.id', cond: :eq },
      'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
      'title' => { name: 'Título', source: 'Expedient.title', cond: :like },
      'user_name' => {name: "Responsable", source: 'User.name',
        cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("users.first_name || ' ' || users.last_name").matches("%#{ search }%")
        }},
      'created_at' => { name: 'Fecha de creación', source: 'Expedient.created_at', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'init_date' => { name: 'Fecha de inicio', source: 'Expedient.init_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'finish_date' => { name: 'Fecha fin', source: 'Expedient.finish_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'state' => { name: 'Estado', source: 'Expedient.state', cond: :like }
    }

    FileMovement = ExpedientMovement = FILE_MOVEMENT

    PurchaseRequest = {
      'id' => { name: 'ID', source: 'ExpedientRequest.id', cond: :eq },
      'number' => { name: 'Número', source: 'ExpedientRequest.number', cond: :like },
      'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
      'init_date' => { name: 'Fecha de inicio', source: 'ExpedientRequest.init_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'final_date' => { name: 'Fecha de vencimiento', source: 'ExpedientRequest.final_date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'urgency' => { name: 'Urgencia', source: 'ExpedientRequest.urgency', searcheable: false },
      'request_type' => { name: 'Tipo', source: 'ExpedientRequest.request_type', cond: :like },
      'state' => { name: 'Estado', source: 'ExpedientRequest.state', cond: :like }
    }

    Budget = PURCHASE_BUDGET

    Order = {
      'id' => { name: 'ID', source: 'ExpedientOrder.id', cond: :eq },
      'number' => { name: 'Número', source: 'ExpedientOrder.number', cond: :like },
      'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'file_created_at' => { name: 'Creado en', source: 'ExpedientOrder.created_at', cond: :date_range, delimiter: '-yadcf_delim-' },
      'paid' => { name: '¿Pagado?', source: 'ExpedientOrder.paid', searcheable: false },
      'total' => { name: 'Total', source: 'ExpedientOrder.total', cond: :eq },
      'state' => { name: 'Estado', source: 'ExpedientOrder.state', cond: :like }
    }

    Bill = PURCHASE_BILL

    Arrival = {
      'id' => { name: 'ID', source: 'ExpedientArrival.id', cond: :eq },
      'number' => { name: 'Número', source: 'ExpedientArrival.number', cond: :like },
      'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'date' => { name: 'Fecha', source: 'ExpedientArrival.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'punctuation' => { name: 'Puntuación', source: 'ExpedientArrival.punctuation', cond: :eq },
      'state' => { name: 'Estado', source: 'ExpedientArrival.state', cond: :like }
    }

    Devolution = {
      'id' => { name: 'ID', source: 'ExpedientDevolution.id', cond: :eq },
      'number' => { name: 'Número', source: 'ExpedientDevolution.number', cond: :like },
      'file' => { name: 'Expediente', source: 'Expedient.number',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.title").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("files.number").matches("%#{search}%"))}},
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'date' => { name: 'Fecha de devolución', source: 'ExpedientDevolution.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'state' => { name: 'Estado', source: 'ExpedientDevolution.state', cond: :like }
    }

    PaymentOrder = {
      'id' => { name: 'ID', source: 'Purchases::PaymentOrder.id', cond: :eq },
      'number' => { name: 'Número', source: 'Purchases::PaymentOrder.number', cond: :like },
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'date' => { name: 'Fecha de pago real', source: 'Purchases::PaymentOrder.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'state' => { name: 'Estado', source: 'Purchases::PaymentOrder.state', cond: :eq },
      'total' => {name: "Monto", source: "Purchases::PaymentOrder.total", cond: :eq},
      'payment_types' => {name: "Forma de pago", source: "PaymentType.name", searcheable: false},
      'taxes_types' => {name: "Retenciones", source: "Tax.tipo", searcheable: false}
    }
  end

  Inventary = {
    'id' => { name: 'ID', source: 'Inventary.id', cond: :eq },
    'name' => { name: 'Nombre',        source: 'Inventary.name',        cond: :like },
    'code' => { name: 'Código',        source: 'Inventary.code',        cond: :like },
    'category' => { name: 'Categoría',  source: 'ProductCategory.name', cond: :like },
    'available_stock' => { name: 'Stock disponible', source: 'Inventary.available_stock', cond: :eq }
  }

  Box = {
    'id' => { name: 'ID', source: 'Box.id', cond: :eq },
    'name' => { name: 'Nombre',        source: 'Box.name',        cond: :like },
    'code' => { name: 'Código',        source: 'Box.code',        cond: :like },
    'category' => { name: 'Categoría',  source: 'ProductCategory.name', cond: :like },
    'available_stock' => { name: 'Stock disponible', source: 'Box.available_stock', cond: :eq }
  }

  Product = {
    'id'              => { name: 'ID',                source: 'Product.id',               cond: :eq },
    'branch'          => { name: 'Marca',             source: 'Product.branch',           cond: :like },
    'name'            => { name: 'Nombre',            source: 'Product.name',             cond: :like },
    'code'            => { name: 'Código',            source: 'Product.code',             cond: :like },
    'gtin'            => { name: 'G.T.I.N.',          source: 'Product.gtin',             cond: :like },
    'pm '             => { name: 'P.M.',              source: 'Product.pm',               cond: :like },
    'category'        => { name: 'Categoría',         source: 'ProductCategory.name',     cond: :like },
    'family'          => { name: 'Sub-categoria',     source: 'Product.family',           cond: :like},
    'available_stock' => { name: 'Stock disponible',  source: 'Product.available_stock',  cond: :eq },
    'state'           => { name: 'Estado',            source: 'Product.available_stock',  cond: :eq },
    'vigente'         => { name: 'Vigente',           source: 'Product.selectable', cond: :eq}
  }

  ProductValorStock = {
    'id'              => { name: 'ID',                source: 'Product.id',               cond: :eq },
    'branch'          => { name: 'Marca',             source: 'Product.branch',           cond: :like },
    'supplier'        => { name: "Proveedor",         source: "Supplier.name",            cond: :like},
    'code'            => { name: 'Código',            source: 'Product.code',             cond: :like },
    'name'            => { name: 'Nombre',            source: 'Product.name',             cond: :like },
    'category'        => { name: 'Categoría',         source: 'ProductCategory.name',     cond: :like },
    'family'          => { name: 'Sub-categoria',     source: 'Product.family',           cond: :like},
    'available_stock' => { name: 'Stock disponible',  source: 'Product.available_stock',  cond: :eq },
    #'state'           => { name: 'Estado',            source: 'Product.available_stock',  cond: :eq },
    #'vigente'         => { name: 'Vigente',           source: 'Product.selectable', cond: :eq}
    'buy_order_date' => {name: "Fecha compra", source: "Product.buy_price", cond: :eq},
    'buy_order' => {name: "Compra", source: "Product.buy_price", cond: :eq},
    'buy_price' => {name: "Precio compra", source: "Product.buy_price", cond: :eq},
    'buy_price_usd' => {name: "Precio compra USD", source: "Product.buy_price", cond: :eq},
    'sale_price' => {name: "Precio Venta", source: "Product.buy_price", cond: :eq},
    'sale_price_usd' => {name: "Precio Venta USD", source: "Product.buy_price", cond: :eq},
    'valor_total' => {name: "Valor total", source: "Product.buy_price", cond: :eq},
    'valor_total_usd' => {name: "Valor total USD", source: "Product.buy_price", cond: :eq},
  }

  Store = {
    'id'              => { name: 'ID', source: 'Store.id', cond: :eq },
    'name'            => { name: 'Nombre', source: 'Store.name', cond: :like},
    'location'        => { name: 'Ubicación', source: 'Store.location', cond: :like}
  }

  StoreProduct = {
    'id'              => { name: 'ID', source: 'Product.id', cond: :eq },
    'product_name'    => { name: 'Nombre', source: 'Product.name', cond: :like},
    'branch'          => { name: 'Marca',             source: 'Product.branch',           cond: :like },
    'code'            => { name: 'Código',            source: 'Product.code',             cond: :like },
    'gtin'            => { name: 'G.T.I.N.',          source: 'Product.gtin',             cond: :like },
    'quantity'        => { name: 'Cantidad', source: 'Article.available', cond: :eq},
    'state'           => { name: 'Estado',            source: 'Product.available_stock',  cond: :eq },
    'vigente'         => { name: 'Vigente',           source: 'Product.selectable', cond: :eq}
  }

  ImprestSystem = {
    'id' => { name: 'ID', source: 'ImprestSystem.id', cond: :eq },
    'nombre_descriptivo' => { name: 'Nombre descriptivo', source: 'ImprestSystem.nombre_descriptivo', cond: :like },
    'user' => { name: 'Responsable', source: 'User.name', cond: :like },
    'sale_point_number' => { name: 'Punto de venta', source: 'SalePoint.number', cond: :like },
    'fondo_fijo' => { name: 'Fondo fijo',  source: 'ImprestSystem.fondo_fijo', cond: :eq },
    'limite_max' => { name: 'Límite máximo', source: 'ImprestSystem.limite_max', cond: :eq }
  }

  CashSolicitude = {
    'codigo' => { name: 'Código', source: 'CashSolicitude.codigo', cond: :like },
    'estado' => { name: 'Estado', source: 'CashSolicitude.estado', cond: :like },
    'created_at' => { name: 'Registro', source: 'CashSolicitude.created_at', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'motivo' => { name: 'Motivo', source: 'CashSolicitude.motivo', cond: :like },
    'descripcion' => {name: "Descripcion", source: "CashSolicitude.descripcion", cond: :like},
    'comprobantes' => { name: 'Comprobantes', source: 'ExpenseDetail.num_comprobante', cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("expense_details.letra || '-' || expense_details.punto_venta || '-' || expense_details.num_comprobante").matches("%#{search}%")
          .or(
            Arel::Nodes::SqlLiteral.new("expense_details.letra").matches("%#{search}%")
          )}},
    'descrip_comprobantes' => { name: 'Descrip. Comprobantes', source: 'ExpenseDetail.descripcion', cond: :like},
    'retiro' => { name: 'Retiro', source: 'CashWithdrawal.fecha', cond: :date_range, delimiter: '-yadcf_delim-'  },
    'rendicion' => { name: 'Rendición', source: 'CashRefund.fecha', cond: :date_range, delimiter: '-yadcf_delim-'  }
  }

  PaymentType = {
    'id' => {name: "ID", source: 'PaymentType.id', cond: :eq},
    'name' => {name: "Nombre", source: 'PaymentType.name', cond: :like},
    'imputed_in_cash' => {name: "¿Impacta en caja?", source: 'PaymentType.imputed_in_cash', searcheable: false},
  }

  EmittedCheck = {
    'numero' => {name: "Número", source: 'EmittedCheck.numero', cond: :eq},
    'estado' => { name: "Estado", source: 'EmittedCheck.estado', cond: :like },
    'vencimiento' => {name: "Vencimiento", source: 'EmittedCheck.vencimiento', cond: :date_range, delimiter: '-yadcf_delim-' },
    'orden_pago' => { name: "O.P.", source: 'Purchases::PaymentOrder', cond: :eq },
    'chequera' => {name: "Chequera", source: 'Checkbook.number', cond: :eq},
    'banco' => {name: "Banco", source: 'Bank.name', cond: :like},
    'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
    'importe' => {name: "Importe", source: 'EmittedCheck.importe', cond: :eq},
    'importe_pagado' => {name: "Pagos", source: 'EmittedCheck.importe_pagado', cond: :eq},
    'saldo' => {name: "Saldo", source: 'EmittedCheck.saldo', cond: :eq},
  }

  module Reports
    File = {
      'delivery_date' => { name: 'ID', source: 'Expedient.delivery_date', cond: :date_range, delimiter: '-yadcf_delim-' },
      'number' => {name: "Número", source: 'Expedient.number', cond: :like},
      'client' => {name: "Cliente", source: 'Entity.name', cond: :like},
      'pacient_with_number' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                          cond: ->(column, search) {
                            Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")
                            .or(Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient_number'").matches("%#{ search }%"))
                          }},
      'shipments' => {name: "Remito", source: 'ExpedientShipment.number', cond: :like}, 
      'sale_type' => {name: "Tipo", source: 'Expedient.sale_type', cond: :like},
      'title' => {name: "Titulo", source: 'Expedient.title', cond: :like},
      'doctor' => { name: "Doctor", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'doctor'").matches("%#{ search }%")}},
      'sale_orders' => {name: "Ordenes de venta", source: 'ExpedientOrder.number', cond: :like},
      'sellers' => {name: "Vendedores", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'technical' => {name: "Tecnico", source: 'Expedient.technical', cond: :eq},
    }

    BuyIvaMovement = {
      'cbte_tipo' => {name: 'Clase', source: "ExternalBill.cbte_tipo", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
      'pto_venta' => {name: 'Pto Vta', source: 'ExternalBill.sale_point', cond: :like},
      'number' => {name: "Documento", source: "ExternalBill.number", cond: :like},
      'date' => {name: 'Fecha', source: 'ExternalBill.date', cond: :date_range, delimiter: '-yadcf_delim-'},
      'registration_date' => {name: "Registro", source: "ExternalBill.registration_date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'entity' => {name: 'Cliente', source: "Entity.name", cond: :like},
      'cuit' => {name: 'CUIT', source: 'Entity.document_number', cond: :like},
      'net_amount' => {name: 'Neto', source: "ExternalBill.gross_amount", cond: :like},
      'iva_amount' => {name: 'IVA', source: "ExternalBill.iva_amount", cond: :like},
      'no_grav' => {name: 'No Grav.', source: "ExternalBillDetail.neto", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bill_details.iva_aliquot = '01' AND bill_details.neto").eq(search)}},
      'exento' => {name: "Exento", source: "ExternalBillDetail.neto", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bill_details.iva_aliquot = '02' AND bill_details.neto").eq(search)}},
      'per_ib_sla' => {name: 'Perc. IB', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepción de IIBB Salta' AND tributes.amount").eq(search)}},
      'per_ib_juy' => {name: 'Perc. IB', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepción de IIBB Jujuy' AND tributes.amount").eq(search)}},
      'per_ib_cat' => {name: 'Perc. IB', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
            Arel::Nodes::SqlLiteral.new("tributes.description = 'Catamarca' AND tributes.amount").eq(search)}},
      'ret_ib' => {name: 'Ret. IB', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Retención de IIBB' AND tributes.amount").eq(search)}},
      'ret_gcias' => {name: 'Ret. Gcias', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Retención de Ganancias' AND tributes.amount").eq(search)}},
      'per_iva' => {name: 'Per. IVA', source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepción de IVA' AND tributes.amount").eq(search)}},
      'imp_nac' => { name: "Imp. Nac.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Impuestos nacionales' AND tributes.amount").eq(search)}},
      'imp_prov' => { name: "Imp. Prov.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Impuestos provinciales' AND tributes.amount").eq(search)}},
      'imp_mun' => { name: "Imp. Mun.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Impuestos municipales' AND tributes.amount").eq(search)}},
      'imp_int' => { name: "Imp. Int.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Impuestos Internos' AND tributes.amount").eq(search)}},
      'iibb' => { name: "IIBB.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'IIBB' AND tributes.amount").eq(search)}},
      'per_iibb' => { name: "Perc. IIBB", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepción de IIBB' AND tributes.amount").eq(search)}},
      'per_imp_mun' => { name: "Perc. Imp. Mun.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepciones por Impuestos Municipales' AND tributes.amount").eq(search)}},
      'otras_per' => { name: "Otras Perc.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Otras Percepciones' AND tributes.amount").eq(search)}},
      'per_iva_no_cat' => { name: "Perc. IVA no Cat.", source: "ExpedientBillTribute.amount", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("tributes.description = 'Percepción de IVA a no Categorizado' AND tributes.amount").eq(search)}},
      'total' => {name: 'Total', source: "GeneralBill.total", cond: :like}
    }

    SellIvaMovement = {
      'cbte_tipo' => {name: 'Clase', source: "ExternalBill.cbte_tipo", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
      'pto_venta' => {name: 'Pto Venta', source: 'GeneralBill.sale_point', cond: :like},
      'number' => {name: "Documento", source: "GeneralBill.number", cond: :like},
      'date' => {name: 'Fecha', source: 'ExternalBill.date', cond: :date_range, delimiter: '-yadcf_delim-'},
      'entity' => {name: 'Cliente', source: "Entity.name", cond: :like},
      'cuit' => {name: 'CUIT', source: 'Entity.document_number', cond: :like},
      'net_amount' => {name: 'Neto', source: "GeneralBill.gross_amount", cond: :like},
      'iva_105_amount' => {name: 'IVA', source: "GeneralBill.imp_iva", cond: :like},
      'iva_21_amount' => {name: 'IVA', source: "GeneralBill.imp_iva", cond: :like},
      'ex_amount' => {name: 'Exento', source: "GeneralBill.imp_op_ex", cond: :like},
      'perc_ib' => {name: "Perc. IIBB", source: "Tribute.amount", searcheable: false},
      'total' => {name: 'Total', source: "GeneralBill.total", cond: :like},
      'zone' => {name: 'Zona', source: 'Province.name', cond: :like}
      #'iva_aliquot' => {name: 'Alicuota IVA', source: 'GeneralBill.iva_aliquot', cond: :like}
    }

    Bill = {
      'cbte_tipo' => {name: 'Clase', source: "ExternalBill.cbte_tipo", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
      'sale_point' => {name: "Pto. vta", source: 'GeneralBill.sale_point', cond: :like},
      'number' => {name: "Factura", source: 'GeneralBill.number', cond: :like},
      'zone' => {name: "Zona", source: "Province.name", cond: :like},
      'full_name' => {name: "Factura", source: 'GeneralBill.number', searcheable: false},
      'client' => { name: 'Cliente', source: 'Entity.name',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("entities.name").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("entities.denomination").matches("%#{search}%"))}},
      'date' => {name: "Emision", source: 'GeneralBill.date', cond: :date_range, delimiter: '-yadcf_delim-'},
      'fch_vto_pago' => {name: "Vto.", source: "GeneralBill.fch_vto_pago", cond: :date_range, delimiter: '-yadcf_delim-'},
      'total' => {name: "Importe", source: "GeneralBill.total", cond: :eq},
      'total_pay' => {name: "Pagado", source: "GeneralBill.total_pay", cond: :eq},
      'total_left' => {name: "Saldo", source: "GeneralBill.total_left", cond: :eq},
      'pacient' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'external_number' => { name: "Expte.", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
      'external_purchase_order' => {name: "O.C.", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order_number'").matches("%#{ search }%")}},
      'seller' => {name: "Vendedor", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'day'   => { name: "Día", source: "GeneralBill.date", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("EXTRACT( DAY FROM bills.date)").matches("%#{ search }%")}},
      'month'   => { name: "Día", source: "GeneralBill.date", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("EXTRACT( MONTH FROM bills.date)").matches("%#{ search }%")}},
      'year'   => { name: "Día", source: "GeneralBill.date", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("EXTRACT( YEAR FROM bills.date)").matches("%#{ search }%")}},
      'state' => {name: "Estado", source: "GeneralBill.state", cond: :like},
      'cancelation' => {name: "Cancelación", source: "ExpedientReceipt.date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'observation' => {name: "Nota", source: "GeneralBill.observation", cond: :string_in},
      'mora' => {name: "Mora", source: "GeneralBill.date", searcheable: false},
      'usd_price' => {name: "Cotización U.S.D.", source: "GeneralBill.usd_price", cond: :eq},
      'total_usd' => {name: "Total U.S.D.", source: "GeneralBill.total_usd", cond: :eq},
      'sale_type' => {name: "Tipo", source: "Expedient.sale_type", cond: :like}
    }

    BillDetail = {
      'date' => {name: "Fecha", source: 'Sales::Bill.date', cond: :date_range, delimiter: '-yadcf_delim-'},
      'number' => {name: "Factura", source: 'Sales::Bill.number', cond: :like},
      'client_id_medtronic' => {name: "Cliente", source: 'Client.id_medtronic', cond: :like},
      'client' => {name: "Cliente", source: 'Client.name', cond: :like},
      'product_code' => {name: "Product Code", source: 'Sales::BillDetail.product_code', cond: :like},
      'product_desc' => {name: "Product desc", source: 'Sales::BillDetail.id', cond: :like},
      'supplier' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
      'quantity' => {name: "Cantidad", source: 'Sales::BillDetail.quantity', cond: :like},
      'seller' => {name: "Vendedor", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'vencimiento' => {name: "F. vto", source: 'Sales::BillDetail.id', cond: :date_range, delimiter: '-yadcf_delim-' },
    }

    ShipmentDetail = {
      'date' => {name: "Fecha", source: 'ExpedientShipment.date', cond: :date_range, delimiter: '-yadcf_delim-'},
      'bill_number' => {name: "Factura", source: 'ExpedientBill.number', cond: :like},
      'bill_date' => {name: "Fecha Factura", source: 'ExpedientBill.date'},
      'shipment_number' => {name: "Remito", source: 'ExpedientShipment.number', cond: :like},
      'client_id_medtronic' => {name: "Cliente", source: 'Client.id_medtronic', cond: :like},
      'client' => {name: "Cliente", source: 'Client.name', cond: :like},
      'product_code' => {name: "Product Code", source: 'ExpedientShipment.product_code', cond: :like},
      'product_desc' => {name: "Product desc", source: 'ExpedientShipment.product_name', cond: :like},
      'supplier' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
      'quantity' => {name: "Cantidad", source: 'ExpedientShipment.quantity', cond: :like},
      'seller' => {name: "Vendedor", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'vencimiento' => {name: "F. vto", source: 'Sales::BillDetail.id', cond: :date_range, delimiter: '-yadcf_delim-' },
    }

    Shipping = {
      'number' => { name: "Número", source: 'ExpedientShipment.number', cond: :like},
      'date' => { name: "Fecha", source: "ExpedientShipment.date"},
      'entity' => { name: "Cliente", source: "Entity.name", cond: :like},
      'surgery_date' => { name: "Fcha. Cx.", source: "File.surgery_end_date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'importe' => {name: "Importe", source: "ExpedientOrder.total", cond: :like},
      'pacient' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'external_file_number' => {name: "Exp. Ext.", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
      'state' => { name: "Estado", source: "ExpedientShipment.state", cond: :like},
      'substate' => { name: "Sub Estado", source: "Expedient.substate", cond: :like},
      'conformed' => {name: "Conformado", source: "ExpedientShipment.conformed", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("shipments.conformed").eq((search.upcase == "SI" || search.upcase == "S") ? 't' : 'f')}},
      'user' => {name: "Usuario", source: "User.name", cond: :like},
      'location' => {name: "Destino", source: "Location.address", cond: :like},
      'observation' => { name: "Detalle", source: "ExpedientShipment.observation", cond: :string_in},
      'sale_order' => { name: "O.V.", source: "ExpedientOrder.number", cond: :like},
      'file' => {name: "Exp. Int", source: "Expedient.title", cond: :like},
      'sale_type' => {name: "Tipo", source: "Expedient.sale_type", cond: :like},
      'bill' => {name: "Factura", source: "ExpedientBill.number", cond: :like},
      'consumption' => {name: "Consumo", source: "ExpedientConsumption.number", cond: :like},
      'external_purchase_order' => {name: "O.C.", source: 'Expedient.custom_attributes',
        cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order'").matches("%#{ search }%")}},
      'seller' => {name: "Vendedor", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'days_sin_facturar' => {name: "Dias sin facturar", source: "ExpedientShipment.date", searcheable: false},
    }

    CalendarTable = {
      'id' => { name: 'ID', source: 'Expedient.id', cond: :eq },
      'client' => { name: "Cliente", source: 'Entity.name',
                    cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("entities.name").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("entities.denomination").matches("%#{search}%"))}},
      'pacient' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'delivery_date' => { name: "Fecha de entrega", source: "ExpedientBudget.delivery_date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'title' => { name: "Título", source: "Expedient.title", cond: :like},
      'sale_type' => { name: "Tipo", source: "Expedient.sale_type", cond: :like},
      'province' => { name: "Lugar", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'province'").matches("%#{ search }%")}},
      'place' => { name: "Lugar", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'place'").matches("%#{ search }%")}},
      'external_number' => {name: "Exp. Ext.", source: 'Expedient.custom_attributes', cond: ->(column, search) { Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
      'external_purchase_order_number' => {name: "O.C.", source: 'Expedient.custom_attributes',
        cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order_number'").matches("%#{ search }%")}},
      'sale_orders' => { name: "O.V.", source: "ExpedientOrder.number", cond: :like},
      'doctor' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'doctor'").matches("%#{ search }%")}},
      'user' => { name: "Responsable actual", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'state' => {name: "Estado", source: "Expedient.state", cond: :like},
      'shipments' => { name: "Remitos", source: "ExpedientShipment.number", cond: :like},
      'observation' => { name: "Comentarios", source: "ExpedientBudget.observation", searcheable: false},
      'surgical_sheet' => { name: "Foja Quirúrgica", source: "Expedient.surgical_sheet_original_filename", searcheable: false, orderable: false},
      'implant_certificate' => { name: "Foja Quirúrgica", source: "Expedient.implant_original_filename", searcheable: false, orderable: false}
    }

    EmittedCheck = {
      'numero' => {name: "Cheque", source: 'EmittedCheck.numero', cond: :eq},
      'vencimiento' => {name: "F. vto", source: 'EmittedCheck.vencimiento', cond: :date_range, delimiter: '-yadcf_delim-' },
      'created_at' => {name: "F. emision", source: 'EmittedCheck.created_at', cond: :date_range, delimiter: '-yadcf_delim-' },
      'banco' => {name: "Banco", source: 'Bank.name', cond: :like},
      'proveedor' => {name: "Proveedor", source: 'Supplier.name', cond: :like},
      'estado' => { name: "Estado", source: 'EmittedCheck.estado', cond: :like },
      'obs' => { name: "Obs", searcheable: false },
      'importe' => {name: "Importe", source: 'EmittedCheck.importe', cond: :eq},
      'importe_pagado' => {name: "Pagos", source: 'EmittedCheck.importe_pagado', cond: :eq},
      'saldo' => {name: "Saldo", source: 'EmittedCheck.saldo', cond: :eq}
    }

    Arrival = {
      'number' => { name: "Número", source: "ExternalArrival.number", cond: :like},
      'date' => { name: "Fecha", source: "ExternalArrival.date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'supplier_bills' => { name: "Factura", source: "ExternalBill.number", cond: :like},
      'supplier' => { name: "Proveedor", source: "Entity.name", cond: :like},
      'purchase_orders' => { name: "Número", source: "ExpedientOrder.number", cond: :like},
      'files' => { name: "Expediente", source: "Expedient.title", cond: :like},
      'state' => { name: "Estado", source: "ExternalArrival.state", cond: :eq},
      'user' => { name: "Responsable actual", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'observation' => { name: "Observación", source: "ExternalArrival.observation", cond: :like},
      'delivered_shipments' => { name: "Remitos entregados?", source: "ExternalArrival.delivered_shipments", cond: :like, class_name: "text-center"},
    }

    Consumption = {
      'number' => { name: "Número", source: "Surgeries::Consumption.number", cond: :like},
      'surgery_date' => { name: "Fcha. Cx.", source: "File.surgery_end_date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'date' => { name: "Fcha. Consumo", source: "Surgeries::Consumption.date", cond: :like},
      'shipments' => {name: "Rto.", source: "ExpedientShipment.number", cond: :like},
      'file' => {name: "Expte.", source: "Expedient.title", source: :like},
      'pacient' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'client' => { name: "Cliente", source: 'Entity.name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("entities.name").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("entities.denomination").matches("%#{search}%"))}},
      'doctor' => {name: "Médico", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'doctor'").matches("%#{ search }%")}},
      'user' => { name: "Usuario", source: 'User.first_name',
                  cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'state' => { name: "Estado", source: "Surgeries::Consumption.state", cond: :like}
    }

    Purchase = {
      'cbte_tipo' => {name: 'Clase', source: "ExternalBill.cbte_tipo", cond: ->(column, search) {
        Arel::Nodes::SqlLiteral.new("bills.cbte_tipo").matches(ExpedientBill.cbte_short_name_inverse(search))}},
      'sale_point' => {name: "Pto. vta", source: 'GeneralBill.sale_point', cond: :like},
      'number' => {name: "Factura", source: 'GeneralBill.number', cond: :like},
      'cbte_fch' => {name: "Emision", source: 'GeneralBill.cbte_fch', cond: :date_range, delimiter: '-yadcf_delim-'},
      'supplier' => { name: 'Proveedor', source: 'Entity.name',cond: ->(column, search) {
          Arel::Nodes::SqlLiteral.new("entities.name").matches("%#{search}%").or(Arel::Nodes::SqlLiteral.new("entities.denomination").matches("%#{search}%"))}},
      'fch_vto_pago' => {name: "Vto.", source: "GeneralBill.fch_vto_pago", cond: :date_range, delimiter: '-yadcf_delim-'},
      'total' => {name: "Importe", source: "GeneralBill.total", cond: :eq},
      'total_pay' => {name: "Pagado", source: "GeneralBill.total_pay", cond: :eq},
      'total_left' => {name: "Saldo", source: "GeneralBill.total_left", cond: :eq},
      'orders' => {name: "O.C.", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_purchase_order'").matches("%#{ search }%")}},
      'state' => {name: "Estado", source: "GeneralBill.state", cond: :like},
      'cancelation' => {name: "Cancelación", source: "PaymentOrder.date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'observation' => {name: "Nota", source: "GeneralBill.observation", cond: :string_in},
    }

    PaymentOrder = {
      'number' => { name: 'Número', source: 'Purchases::PaymentOrder.number', cond: :like },
      'supplier' => { name: 'Proveedor', source: 'Entity.name', cond: :like },
      'date' => { name: 'Fecha de pago real', source: 'Purchases::PaymentOrder.date', cond: :date_range, delimiter: '-yadcf_delim-'  },
      'state' => { name: 'Estado', source: 'Purchases::PaymentOrder.state', cond: :eq },
      'total' => { name: "Total", source: "Purchases::PaymentOrder.total", cond: :eq},
      'total_pay' => { name: "Pagos y retenciones", source: "Purchases::PaymentOrder.total", searcheable: false}
    }

    Expedient = {
      'number' => { name: 'Número', source: 'Expedient.number', cond: :like },
      'sellers' => {name: "Vendedores", source: 'User.first_name',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("UPPER(users.first_name || ' ' || users.last_name)").matches("%#{ search.upcase }%")}},
      'state' => { name: "Estado", source: "Expedient.state", cond: :like},
      'pacient' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'pacient_number' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient_number'").matches("%#{ search }%")}},
      'external_number' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'external_number'").matches("%#{ search }%")}},
      'entity' => { name: "Cliente", source: 'Entity.name',cond: :like},
      'sale_orders_total' => {name: "O.V. total", source: "ExpedientOrder.total", searcheable: false},
      'products_family' => {name: "Materiales", source: "Inventary.family", cond: :like},
      'doctor' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'doctor'").matches("%#{ search }%")}},
      'shipments' => { name: "Rtos.", source: "ExpedientShipments.number", cond: :like},
      'institution' => {name: "Institución", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'place'").matches("%#{ search }%")}},
      'shipments_dates' => {name: "Fcha. remitos", source: "ExpedientShipments.date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'mora' => {name: "Mora", source: "Expedient.finish_date", searcheable: false}

    }

    ExpedientState = {
      'title' => {name: "Expediente", source: "Expedient.title", cond: :like},
      'have_implant_certificate' => {name: "Crt. Implante", source: 'Expedient.custom_attributes',
              cond: ->(column, search) {
                Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'implant_certificate'").matches("%#{ search }%")}},
      'have_surgical_sheet' => {name: "Crt. Implante", source: 'Expedient.custom_attributes',
              cond: ->(column, search) {
                Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'surgical_sheet'").matches("%#{ search }%")}},
      'have_note' => {name: "Nota", source: 'Expedient.custom_attributes',
              cond: ->(column, search) {
                Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'note'").matches("%#{ search }%")}},
      'have_sticker' => {name: "Stickers", source: 'Expedient.custom_attributes',
              cond: ->(column, search) {
                Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'sticker'").matches("%#{ search }%")}},
      'have_sale_order_attachements' => {name: "O.C.", source: "Attachement.original_filename", cond: :like},
      'have_partial_delivery' => { name: "Entrega parcial", source: "Expedient.substate", cond: :like},
      'have_full_delivery' => { name: "Entrega total", source: "Expedient.substate", cond: :like}
    }

    Costing = {
      'title' => {name: "Expediente", source: "Expedient.title", cond: :like},
      'surgery_end_date' => {name: "Fecha", source: "Expedient.surgery_end_date", cond: :date_range, delimiter: '-yadcf_delim-'},
      'doctor' => {name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'doctor'").matches("%#{ search }%")}},
      'patient' => { name: "Afiliado", source: 'Expedient.custom_attributes',
                    cond: ->(column, search) {
                      Arel::Nodes::SqlLiteral.new("files.custom_attributes -> 'pacient'").matches("%#{ search }%")}},
      'entity' => { name: "Cliente", source: 'Entity.name',cond: :like},
      'sale_orders_total' => {name: "O.V. total", source: "ExpedientOrder.total", searcheable: false},
      'state' => {name: "Estado", source: "Expedient.state", cond: :like},
      'margin' => {name: "Margen", source: "Expedient.margin", seracheable: false, orderable: false},
      'suppliers' => {name:"Proveedores", source: "Supplier.name", searcheable: true}
    }

    Client = {
      'name' => {name: "Nombre", source: "Client.name", cond: :like},
      'current_balance' => {name: "Balance", source: "Client.current_balance", cond: :like}
    }

  end
end
