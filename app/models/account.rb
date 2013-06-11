class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :destroy

  before_save do
    slug.downcase!
  end

  default_scope -> { order('lower(name)') }

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  VALID_USERNAME_REGEX = /\A[\w-]+\z/i
  validates :slug, presence: true,
                   length: { maximum: 50 },
                   format: { with: VALID_USERNAME_REGEX },
                   uniqueness: { case_sensitive: false, scope: :user_id }

  def to_param # overridden
    slug
  end

end
