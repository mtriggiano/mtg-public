class Finances::PaymentTypesController < ApplicationController
	expose :payment_types, ->{current_company.payment_types}
	expose :payment_type, scope: ->{payment_types}

	def index
	  @cash_accounts = current_company.cash_accounts
	  @regular_cash_accounts = current_company.regular_cash_accounts
	end

	def create
		if payment_type.save
			redirect_to payment_types_path, notice: t('.success')
		else
			show_development_errors
			render :new
		end
	end

	def update
		if payment_type.update(payment_type_params)
			redirect_to payment_types_path, notice: t('.success')
		else
			show_development_errors
			render :edit
		end
	end

	def destroy
		if payment_type.destroy
			redirect_to payment_types_path, notice: t('.success')
		else
			show_development_errors
			render :show
		end
	end

	private

	def payment_type_params
		params.require(:payment_type).permit(:name, :imputed_in_cash, :collect_type, :cash_account_id)
	end

	def show_development_errors
		pp payment_type.errors if Rails.env == "development"
	end
end
