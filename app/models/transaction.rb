class Transaction < ActiveRecord::Base
  belongs_to :account

  default_scope -> { order('moment DESC') }

  validates :account_id, presence: true
  validates :value, presence: true
  validates :moment, presence: true
  validates :description, presence: true, length: { maximum: 100 }
end
