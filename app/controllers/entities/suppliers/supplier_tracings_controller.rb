class Suppliers::SupplierTracingsController < ApplicationController

  expose :suppliers, -> { current_company.suppliers }
  expose :supplier, scope: -> {suppliers}

  def index
    # code
  end

end
