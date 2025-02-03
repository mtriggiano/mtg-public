class InitialBalance < DailyCashBalance
  default_scope -> { where(apertura: true) }
end
