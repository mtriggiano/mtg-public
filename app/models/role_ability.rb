class RoleAbility < ApplicationRecord
  self.table_name = :abilities
  belongs_to :role, inverse_of: :abilities
  has_many :ability_actions, foreign_key: :ability_id, dependent: :destroy, inverse_of: :ability

  accepts_nested_attributes_for :ability_actions, reject_if: :all_blank, allow_destroy: true

  DEFAULT_ACTIONS = [
    ['Acceso total', :manage],
    ['Ver', :show],
    ['Crear', :create],
    ['Modificar', :update],
    ['Eliminar', :destroy]
  ]

  DEFAULT_CLASSES = {
    'Ventas' => [
      [ 'Ventas: Expedientes', 'Sales::File'],
      [ 'Ventas: Movimientos', 'Sales::FileMovement'],
      [ 'Ventas: Solicitudes', 'Sales::SaleRequest'],
      [ 'Ventas: Presupuestos', 'Sales::Budget'],
      [ 'Ventas: Orden de venta', 'Sales::Order'],
      [ 'Ventas: Remitos', 'Sales::Shipment'],
      [ 'Ventas: Facturación', 'Sales::Bill']
    ],
    'Compras' => [
      [ 'Compras: Expedientes', 'Purchases::File'],
      [ 'Compras: Movimientos', 'Purchases::FileMovement'],
      [ 'Compras: Solicitudes', 'Purchases::PurchaseRequest'],
      [ 'Compras: Presupuestos', 'Purchases::Budget'],
      [ 'Compras: Orden de compra', 'Purchases::Order'],
      [ 'Compras: Remitos', 'Purchases::Arrival'],
      [ 'Compras: Facturación', 'Purchases::Bill'],
      [ 'Compras: Orden de pago', 'Purchases::PaymentOrder'],
      [ 'Compras: Devoluciones', 'Purchases::Devolution']
    ],
    'Licitaciones' => [
      [ 'Licitaciones: Expedientes', 'Tenders::File'],
      [ 'Licitaciones: Movimientos', 'Tenders::FileMovement'],
      [ 'Licitaciones: Presupuestos', 'Tenders::Budget'],
      [ 'Licitaciones: Orden de venta', 'Tenders::Order'],
      [ 'Licitaciones: Remitos', 'Tenders::Shipment'],
      [ 'Licitaciones: Facturación', 'Tenders::Bill'],
    ],
    'Convenio' => [
      [ 'Convenio: Solicitudes', 'AgreementSurgeries::SurgeryRequest'],
      [ 'Convenio: Materiales', 'AgreementSurgeries::SurgeryMaterial'],
      [ 'Convenio: Expedientes', 'AgreementSurgeries::File'],
      [ 'Convenio: Actualizacion de precios', 'AgreementSurgeries::PriceUpdate'],
      [ 'Convenio: Ordenes de Venta', 'AgreementSurgeries::SaleOrder'],
      [ 'Convenio: Remitos', 'AgreementSurgeries::Shipment'],
    ],
    'Cirugías' => [
      [ 'Cirugías: Expedientes', 'Surgeries::File'],
      [ 'Cirugías: Movimientos', 'Surgeries::FileMovement'],
      [ 'Cirugías: Recetas', 'Surgeries::Prescription'],
      [ 'Cirugías: Presupuestos', 'Surgeries::Budget'],
      [ 'Cirugías: Orden de venta', 'Surgeries::SaleOrder'],
      [ 'Cirugías: Solicitudes', 'Surgeries::PurchaseRequest'],
      [ 'Cirugías: Pedidos', 'Surgeries::SupplierRequest'],
      [ 'Cirugías: Entradas', 'Surgeries::Arrival'],
      [ 'Cirugías: Salidas', 'Surgeries::Shipment'],
      [ 'Cirugías: Consumos', 'Surgeries::Consumption'],
      [ 'Cirugías: Devoluciones', 'Surgeries::Devolution'],
      [ 'Cirugías: Orden de compra', 'Surgeries::PurchaseOrder'],
      [ 'Cirugías: Cobros', 'Surgeries::ClientBill'],
      [ 'Cirugías: Pagos', 'Surgeries::SupplierBill'],
      [ 'Cirugías: Adjuntos', 'Attachment'],
    ],
    'Almacén' => [
      [ 'Almacén: Categorías', 'ProductCategory' ],
      [ 'Almacén: Cajas', 'Box' ],
      [ 'Almacén: Productos', 'Product'],
      [ 'Almacen: Lotes', 'Batch'],
      [ 'Almacen: Arribos', 'ExternalArrival'],
      [ 'Almacen: Salidas', 'ExternalShipment'],
      [ 'Almacen: Depósitos', 'Store'],
      [ 'Reportes de almacen: Salidas', 'Reports::Shipping'],
      [ 'Reportes de almacen: Entradas', 'Reports::Arrival'],
    ],
    'Proveedores' => [
      [ 'Proveedores: Proveedores', 'Supplier' ],
      [ 'Proveedores: Contactos', 'SupplierContact' ],
      [ 'Proveedores: Registros', 'SupplierContactRecord' ],
      [ 'Proveedores: Cuenta corriente', 'SupplierAccountMovement'],
      [ 'Proveedores: Facturación', 'ExternalBill'],
    ],
    'Clientes' => [
      [ 'Clientes: Clientes', 'Client' ],
      [ 'Clientes: Contactos', 'ClientContact' ],
      [ 'Clientes: Registros', 'ClientContactRecord' ],
      [ 'Clientes: Recibo', 'ExpedientReceipt'],
      [ 'Clientes: Cuenta corriente', 'ClientAccountMovement'],
    ],
    'Compania' => [
      [ 'Companias: Companias', 'Company' ],
    ],
    'Roles' => [
      [ 'Roles: Roles', 'Role']
    ],
    'Finanzas' => [
      ['Finanzas: Caja general', 'GeneralCashAccount'],
      ['Finanzas: Caja chica', 'RegularCashAccount'],
      ['Finanzas: Cuentas bancarias', 'BankAccount'],
      ['Finanzas: Configuración de tipos de pago', 'PaymentType'],
      ['Finanzas: Cheques emitidos', 'EmittedCheck'],
      ['Finanzas: Gastos abonados', 'Expenditure'],
      ['Finanzas: Solicitudes de fondos', 'CashSolicitude'],
      ['Finanzas: Arqueos de caja', 'InitialBalance'],
      ['Finanzas: Imputaciones en caja general', 'GeneralCashAccountPayment']
    ],
    'RRHH' => [
      ['RRHH: Empleados', 'User'],
      ['RRHH: Turnos de trabajo', 'AttendanceCategory'],
      ['RRHH: Dias no laborales', 'NonWorkingDay'],
      ['RRHH: Asistencias', 'Attendance'],
      ['RRHH: Resumen Mensual', 'AttendanceResume'],
      ['RRHH: Vacaciones', 'UserVacation'],
      ['RRHH: Permisos', 'Permission'],
      ['RRHH: Empleados ausentes', 'NonPresentUser'],
      ['RRHH: Puestos de trabajo', 'WorkStation']
    ],
    'Calendarios' => [['Calendarios: Modificar', 'Calendar']],
    'Reportes' => [
      ['Reportes: Ventas', 'Reports::Bill'],
      ['Reportes: Remitos', 'Reports::Shipment'],
      ['Reportes: Clientes', 'Reports::ClientReport'],
      ['Reportes: IVA Ventas', 'Reports::SellIvaMovement'],
      ['Reportes: Compras', 'Reports::Purchase'],
      ['Reportes: IVA Compras', 'Reports::BuyIvaMov'],
      ['Reportes: Almacén', 'Reports::Storage'],
      ['Reportes: Cobranzas', 'Reports::Receipt'],
      ['Reportes: Finanzas', 'Reports::Finrep'],
      ['Reportes: Medtronic', 'Reports::MedtronicReport'],
      ['Reportes: Todos', 'Reports::AllReports']
]

  }

    def ability_actions=(actions)
      self.ability_actions.each(&:destroy)
      actions.each do |action|
        self.ability_actions.where(name: action).first_or_initialize
      end
    end
end
