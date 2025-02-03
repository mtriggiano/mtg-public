class Finances::BankAccountImporterConfigurationsController < ApplicationController
  skip_load_and_authorize_resource
  expose :bank_accounts, -> { current_company.bank_accounts }
  expose :bank_account, id: -> { params[:bank_account_id] }, scope: -> { bank_accounts }
  expose :configuration, -> { bank_account.configuration }

  def new
    configuration = bank_account.build_configuration
  end

  def create
    configuration = bank_account.build_configuration(ba_configuration_params)
    configuration.save
    render :handle_response
  end

  def edit
  end

  def update
    configuration.update(ba_configuration_params)
    render :handle_response
  end

  private

  def ba_configuration_params
    params.require(:bank_account_importer_configuration).permit(:fecha, :descripcion, :credito, :debito, :saldo, :amount, :amount_column_type_unique)
  end
end
