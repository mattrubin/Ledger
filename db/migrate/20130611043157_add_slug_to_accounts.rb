class AddSlugToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :slug, :string
    add_index  :accounts, [:user_id, :slug], unique: true

    Account.all.each do |account|
      account.slug = account.id
      account.save!
    end
  end
end
