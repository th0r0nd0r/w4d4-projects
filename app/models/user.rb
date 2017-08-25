class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 3, allow_nil: true }

  after_initialize :ensure_session_token
  attr_reader :password

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
