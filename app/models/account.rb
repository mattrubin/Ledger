class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions
  
  default_scope -> { order('lower(name)') }

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
end
