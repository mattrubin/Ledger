class User < ActiveRecord::Base
  has_many :accounts, dependent: :destroy

  before_save do
    email.downcase!
    username.downcase!
  end
  before_save :create_remember_token


  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  VALID_USERNAME_REGEX = /\A[\w]+\z/i
  validates :username, presence: true,
                       length: { maximum: 20 },
                       format: { with: VALID_USERNAME_REGEX },
                       uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 10 }

  def to_param # overridden
    username
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
