class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :description
      t.decimal :value
      t.uuid :account_id

      t.timestamps
    end
    add_index :transactions, :account_id
  end
end
