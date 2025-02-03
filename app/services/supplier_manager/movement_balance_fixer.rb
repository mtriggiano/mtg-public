# module SupplierManager
#   class MovementBalanceFixer < ApplicationService
#
#     def initialize supplier
#
#       @supplier = supplier
#     end
#
#     def call
#       fix_movements
#     end
#
#     private
#
#     def fix_movements
#       @supplier.update_columns(current_balance: 0)
#       @supplier.account_movements.order(id: :asc).each do |movement|
#         movement.balance = calcula_balance(movement)
#         movement.save
#         @supplier.update_column(:current_balance, movement.balance)
#       end
#     end
#
#     def calcula_balance(movement)
#       @supplier.current_balance + total_por_tipo(movement.payment_bill, movement.payment_order)
#     end
#
#     def total_por_tipo(payment_bill, payment_order)
#       if payment_bill
#         return payment_bill.total.round(2) if payment_bill.is?(:bill)
#         return - payment_bill.total.round(2) if payment_bill.is?(:credit_note)
#         return payment_bill.total.round(2) if payment_bill.is?(:debit_note)
#       elsif payment_order
#         return - payment_order.total.round(2)
#       else
#         return 0
#       end
#     end
#
#   end
# end
