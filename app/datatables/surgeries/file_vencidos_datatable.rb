class Surgeries::FileVencidosDatatable < ApplicationDatatable
  def data
    records.map do |record|
    presenter = Surgeries::FileVencidosPresenter.new(record, @view)
    result = Hash.new
    DatatableConstants::Surgeries::FileVencidos.keys.map do |col|
        result[col.to_sym] = eval("presenter.#{col}")
    end
    result[:actions] = presenter.action_links
    result[:DT_RowId] = record.id
    result
    end
  end

  def view_columns
    @view_columns = Hash.new
    DatatableConstants::Surgeries::FileVencidos.map do |k, v|
    @view_columns[k.to_sym] = v.except(:name)
    end
    @view_columns[:links] = {}
    return @view_columns
  end

  def get_raw_records
    @collection.includes(:cx_notificacions, sale_orders: :sellers).references(:users)
  end   
end
