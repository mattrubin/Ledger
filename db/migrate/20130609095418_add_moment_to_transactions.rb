class AddMomentToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :moment, :datetime
  end
end
