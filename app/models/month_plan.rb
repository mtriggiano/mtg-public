class MonthPlan
  include ActiveModel::Model

  attr_accessor :start_time, :cobros, :pagos

  validates_presence_of :start_time, :cobros, :pagos
end
