class Surgeries::PurchaseRequestDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:file)
  end

  def filter_pacient_condition
    ->(column, search) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
  end

end
