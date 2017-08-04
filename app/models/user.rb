class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Realtionship",
                                 foreign_key: "follower_id",
                                 dependent:  :destroy
  has_many :passive_relationships, class_name: "Realtionship",
                                 foreign_key: "followed_id",
                                 dependent:  :destroy
  has_many :following, through: :active_relationships
  has_many :followers, through: :passive_relationships


	attr_accessor :remember_token, :activation_token
	before_save :downcase_email
	before_create :create_activation_digest

	before_save { self.email = email.downcase }
	validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
	                	format: { with: VALID_EMAIL_REGEX },
	                uniqueness: { case_sensitive: false }


	has_secure_password	
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	
  def feed
    Micropost.where("user_id = ?", id)
  end
  
	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
   	SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def activate
    update_columns(activated: FILL_IN, activated_at: FILL_IN)
  end

  def create_activation_digest
		self.activation_token  = User.new_token
		self.activation_digest = User.digest(activation_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def downcase_email
    self.email = email.downcase
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
	
end
