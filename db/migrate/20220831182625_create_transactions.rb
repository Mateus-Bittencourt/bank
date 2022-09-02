class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.float :current_balance, null: false, default: 0
      t.float :new_balance, null: false, default: 0
      t.string :type, null: false
      t.float :amount, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :destination_account
      t.timestamps
    end
    add_foreign_key :transactions, :users, column: :destination_account_id
  end
end
