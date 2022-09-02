class Transaction < ApplicationRecord
  belongs_to :user
  # validates :type, inclusion: { in: ['Depósito', 'Saque', 'Transferências entre Contas', 'Extrato'],
  #   message: "%{value} não é uma operação válida" }
end
