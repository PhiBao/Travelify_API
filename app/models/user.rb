# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  password_digest        :string
#  email                  :string
#  phone_number           :string
#  address                :string
#  birthday               :date
#  activation_digest      :string
#  activated_at           :datetime
#  activated              :boolean          default("false")
#  admin                  :boolean          default("false")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  reset_password_digest  :string
#  reset_password_sent_at :datetime
#  provider               :string
#  uid                    :string
#
# Indexes
#
#  index_users_on_email             (email) UNIQUE
#  index_users_on_provider_and_uid  (provider,uid) UNIQUE
#

require 'open-uri'

class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_secure_password
  attr_accessor :activation_token, :reset_password_token
  before_save   :downcase_email
  
  has_one_attached :avatar, dependent: :destroy do |attachable|
    attachable.variant :thumb, resize: "64x64"
  end
  has_many :bookings, dependent: :nullify
  has_many :actions, dependent: :nullify
  has_many :reviews, dependent: :nullify

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX
  validates :phone_number, numericality: { only_integer: true }, length: { minimum: 9, maximum: 11 }, allow_blank: true
  validates :address, length: { maximum: 100 }
  validates :avatar, content_type: [:png, :jpg, :jpeg, :gif],
                     size:         { less_than: 5.megabytes }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def full_name
    "#{self.first_name || ""} #{self.last_name || ""}"
  end

  def avatar_url
    return unless self.avatar.attached?
    url_for(self.avatar)
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Activates an account.
  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    update activation_digest: User.digest(activation_token)
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_password_token = User.new_token
    update(reset_password_digest: User.digest(reset_password_token),
           reset_password_sent_at: Time.zone.now)
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_password_sent_at < 2.hours.ago
  end

  # Socila login
  def self.from_omniauth(auth)
    where(email: auth[:info][:email]).first_or_create do |user|
      user.provider = auth[:provider]
      user.uid = auth[:uid]
      user.email = auth[:info][:email]
      user.first_name = auth[:info][:first_name]
      user.last_name = auth[:info][:last_name]
      user.password = User.new_token
      downloaded_image = URI.parse(auth[:info][:avatar]).open
      user.avatar.attach(io: downloaded_image, filename: "#{auth[:uid]}.jpg")
      user.activated = true
      user.activated_at = Time.zone.now
    end
  end

  private
  
  # Converts email to all lower-case. 
  def downcase_email
    self.email.downcase!
  end
end
