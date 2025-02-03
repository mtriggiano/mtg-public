module CompanyManager
  class GeneralCashAccountGenerator < ApplicationService
    attr_accessor :company
    def initialize(company)
      @company = company
    end

    def call
      ActiveRecord::Base.transaction do
        if company.general_cash_account.nil?
          general_cash_account = GeneralCashAccount.new.tap do |caja_general|
            caja_general.nombre      = "Caja General"
            caja_general.company_id  = company.id
          end
          general_cash_account.save!
        end
      end
    end
  end
end
