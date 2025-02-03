class AlertUser < ApplicationRecord
    self.table_name  =:alerts_users
    belongs_to :user
    belongs_to :alert
end