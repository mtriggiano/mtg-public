class ExpedientShipmentCustomDetail < ApplicationRecord

  self.table_name = :shipment_details

  default_scope ->{where(custom_detail: true)}
end