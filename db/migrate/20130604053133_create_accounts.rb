class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.uuid :user_id

      t.timestamps
    end
    add_index :accounts, :user_id
  end
end
