class AddBalanceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :float, null: false, default: 0
    add_column :users, :full_name, :string, null: false
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
    add_column :users, :account_number, :string, null: false, unique: true, default: "00000"
    add_column :users, :cpf, :string, null: false, unique: true
    add_index :users, :account_number
    add_index :users, :cpf

  end
end
