class Ability
  include CanCan::Ability

  def initialize(user)
    # Clases de documentos con permisos especiales de edición
    document_classes = [
      "ExternalBill", "ExternalArrival", "Purchases::PurchaseRequest", "Purchases::Budget", 
      "Purchases::Order", "Purchases::Arrival", "Purchases::Bill", "Purchases::PaymentOrder", 
      "Purchases::Devolution", "Tenders::Budget", "Tenders::Order", "Tenders::Shipment", 
      "Tenders::Bill", "Surgeries::Prescription", "Surgeries::Budget", "Surgeries::SaleOrder", 
      "Surgeries::PurchaseRequest", "Surgeries::SupplierRequest", "Surgeries::Arrival", 
      "Surgeries::Consumption", "Surgeries::Shipment", "Surgeries::PurchaseOrder", 
      "Surgeries::ClientBill", "Surgeries::SupplierBill", "Sales::SaleRequest", "Sales::Budget", 
      "Sales::Order", "Sales::Shipment", "Sales::Bill"
    ]

    return unless user

    # Permisos para superadmin
    if user.company_owner?
      can :manage, :all
      return
    end

    # Permisos para el rol "Reportes"
    if user.roles.exists?(name: 'TODOS LOS REPORTES') || user.has_permission?(:all_reports)
      can :access, :reports
      can :read, Reports::Bill
      can :read, Reports::Shipment
      can :read, Reports::ClientReport
      can :read, Reports::SellIvaMovement
      can :read, Reports::Purchase
      can :read, Reports::BuyIvaMov
      can :read, Reports::Storage
      can :read, Reports::Receipt
      can :read, Reports::Finrep
      can :read, Reports::MedtronicReport
    else
      # Permisos específicos para cada reporte
      assign_individual_report_permissions(user)
    end

    # Aplicación de permisos específicos de cada rol y acción
    apply_role_based_permissions(user, document_classes)
  end

  private

  def assign_individual_report_permissions(user)
    # Permiso de acceso general a "reportes" si el usuario tiene al menos uno de los permisos específicos
    if user.has_any_permission?(:reports_bill, :reports_shipment, :reports_client_report, 
                                :reports_sell_iva_movement, :reports_purchase, 
                                :reports_buy_iva_mov, :reports_storage, 
                                :reports_receipt, :reports_finrep, :reports_medtronic_report)
      can :access, :reports
    end

    # Permisos individuales
    can :read, Reports::Bill if user.has_permission?(:reports_bill)
    can :read, Reports::Shipment if user.has_permission?(:reports_shipment)
    can :read, Reports::ClientReport if user.has_permission?(:reports_client_report)
    can :read, Reports::SellIvaMovement if user.has_permission?(:reports_sell_iva_movement)
    can :read, Reports::Purchase if user.has_permission?(:reports_purchase)
    can :read, Reports::BuyIvaMov if user.has_permission?(:reports_buy_iva_mov)
    can :read, Reports::Storage if user.has_permission?(:reports_storage)
    can :read, Reports::Receipt if user.has_permission?(:reports_receipt)
    can :read, Reports::Finrep if user.has_permission?(:reports_finrep)
    can :read, Reports::MedtronicReport if user.has_permission?(:reports_medtronic_report)
  end

  def apply_role_based_permissions(user, document_classes)
    user.roles.includes(abilities: :ability_actions).each do |role|
      role.abilities.each do |permission|
        permission.ability_actions.each do |action|
          # Condición para evitar la conversión de 'Reports::AllReports' a constante
          if permission.class_name == "Reports::AllReports"
            can action.name.to_sym, :all_reports
          else
            assign_permission_based_on_action(action, permission, document_classes)
          end
        end
      end
    end
  end

  def assign_permission_based_on_action(action, permission, document_classes)
    case action.name.to_sym
    when :update
      can [:edit, :update], permission.class_name.constantize
    when :show
      can [:show, :read, :index], permission.class_name.constantize
      can :edit, permission.class_name.constantize if document_classes.include?(permission.class_name)
    when :create
      can [:new, :create, :edit], permission.class_name.constantize
    when :approve
      can [:approve, :edit, :update], permission.class_name.constantize
    else
      can action.name.to_sym, permission.class_name.constantize
    end
  end
end