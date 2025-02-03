class Reports::FileDatatable < ApplicationDatatable

  def data
    records.map do |record|
      presenter = Reports::FilePresenter.new(record, @view)
      result = Hash.new
      DatatableConstants::Reports::File.keys.map do |col|
        result[col.to_sym] = eval("presenter.#{col}")
      end
      result[:actions] = presenter.action_links
      result[:DT_RowId] = record.id
    result
    end
  end

  def view_columns
    @view_columns = Hash.new
    DatatableConstants::Reports::File.map do |k, v|
      @view_columns[k.to_sym] = v.except(:name)
    end
    @view_columns[:links] = {}
  return @view_columns
  end

  def get_raw_records
    @collection.includes(:entity, :expedient_shipments, :sale_orders,  expedient_budgets: :seller)
    .references(:entity, :expedient_shipments, :sale_orders, :expedient_budgets, :seller)
  end
end
