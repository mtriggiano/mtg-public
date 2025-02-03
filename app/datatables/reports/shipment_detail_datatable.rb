class Reports::ShipmentDetailDatatable < ApplicationDatatable

  def data
    records.map do |record|
      presenter = Reports::ShipmentDetailPresenter.new(record, @view)
      result = Hash.new
      DatatableConstants::Reports::ShipmentDetail.keys.map do |col|
        result[col.to_sym] = eval("presenter.#{col}")
      end
      result[:actions] = presenter.action_links
        result[:DT_RowId] = record.id
      result
    end
  end
  
  def view_columns
    @view_columns = Hash.new
    DatatableConstants::Reports::ShipmentDetail.map do |k, v|
      @view_columns[k.to_sym] = v.except(:name)
    end
    @view_columns[:links] = {}
    return @view_columns
  end
  
  def get_raw_records
    @collection.includes(product: :supplier, shipment: [:client, :all_details, { expedient_bills: [:sellers]}])
    #@collection.includes(product: :supplier, shipment: [:client, :all_details, { expedient_bills: [:sellers]}]).references(:entities, :products)
    #.includes(product: [:supplier], bill: [:client, :sellers, {bills_shipments: [shipment: [{details: [:product,  batch_details: :batch ]}]] } ] )

  end
end
