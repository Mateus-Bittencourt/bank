class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.float :bank_fee, null: false, default: 0
      t.float :old_balance, null: false, default: 0
      t.float :new_balance, null: false, default: 0
      t.float :destination_account_old_balance
      t.float :destination_account_new_balance
      t.string :transaction_type, null: false
      t.float :amount, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :destination_account
      t.timestamps
    end
    add_foreign_key :transactions, :users, column: :destination_account_id
  end
end
