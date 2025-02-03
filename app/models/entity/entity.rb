class Entity < ApplicationRecord
  include Notificable
    include Virtus.model(constructor: false, mass_assignment: false)
    attribute :user, User
    alias_method :current_user, :user

    belongs_to :company
    belongs_to :province, optional: true
    has_many   :activities, as: :activitable
    #has_many   :account_movements, dependent: :destroy
    has_many   :budgets
    has_many   :bills
    has_many   :entity_banks

    IVA_COND = Company::IVA_COND
    SECTORS = ["Público", "Privado"]

    validates_presence_of :name, message: "El nombre no puede estar en blanco"
    validates_uniqueness_of :name, scope: [:active, :company_id, :type], message: "Ya existe un cliente con ese nombre", case_sensitive: false
    validates_uniqueness_of :document_number, scope: [:active, :company_id, :type], message: "Ya existe un cliente con ese documento", if: Proc.new{|c| c.parent_id.nil?}
    validate :document_validator
    validates_length_of :name, maximum: 70, message: "Máximo 30 caracteres en el nombre"
    validates_length_of :address, maximum: 100, message: "Máximo 100 caracteres en la dirección"
    validates_presence_of :iva_cond, message: "Debe especificar la condición ante I.V.A."
    validates_inclusion_of :iva_cond, in: IVA_COND, message: "Tipo de condición ante I.V.A. inválida"
    validates_numericality_of :recharge, message: "El recargo solo acepta caracteres numéricos", allow_blank: true

    accepts_nested_attributes_for :entity_banks, reject_if: :all_blan, allow_destroy: true

    def document_validator
        document_validations = DocumentValidator.new(document_type: document_type, document_number: document_number)
        unless document_validations.valid?
            document_validations.errors.messages.each do |error|
                errors.add(error.first, error.last.join(", "))
            end
        end
    end

    def full_document
        "#{Afip::DOCUMENTOS.map{|name, val| name if val == document_type}.compact.join()}: #{document_number}"
    end

    def iva_cond_sym
        iva_cond.parameterize.underscore.gsub(" ", "_").to_sym
    end

    def recharge=(val)
        super val.to_f.round(2)
    end

    def total_budgeted
        budgets.pluck(:total).sum.round(2)
    end

    def total_selled
        bills.not_credito_notes.pluck(:total).inject(0, :+)
    end

    def current_balance
      read_attribute("current_balance").round(2)
    end

    def current_debt
      read_attribute("current_balance").round(2)
    end

    def set_activity(current_user=nil)
        activities.build(user: user || current_user)
    end

    def emails
        contacts.map(&:email).join(", ")
    end
end
