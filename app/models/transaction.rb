class Transaction < ActiveRecord::Base
  belongs_to :account

  validates :account_id, presence: true
  validates :value, presence: true
  validates :description, presence: true, length: { maximum: 100 }
end
