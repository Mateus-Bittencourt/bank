class Transaction < ApplicationRecord
  belongs_to :user
  validates :bank_fee, :old_balance, :new_balance, :amount, presence: true
  # validates :type, inclusion: { in: ['Depósito', 'Saque', 'Transferências entre Contas', 'Extrato'],
  #   message: "%{value} não é uma operação válida" }
end
