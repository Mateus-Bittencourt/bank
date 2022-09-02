class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.float :balance, default: 0, null: false

      t.timestamps
    end
  end
end
