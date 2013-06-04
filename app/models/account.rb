class Account < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('lower(name)') }
  validates :user_id, presence: true
end
