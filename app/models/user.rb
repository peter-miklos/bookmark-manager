require_relative '../data_mapper_setup'
require 'bcrypt'
require 'securerandom'

class User
  include DataMapper::Resource

  property :id,     Serial
  property :email,  String, :required => true, :unique => true
  property :password_digest, Text
  property :password_token, Text
  property :password_token_time, Time

  attr_accessor :password_confirmation
  attr_reader :password

  validates_confirmation_of :password
  validates_format_of :email, :as => :email_address

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      false
    end
  end

  def generate_token
    self.password_token = SecureRandom.hex
    self.password_token_time = Time.now
    self.save
  end

  def self.find_by_valid_token(token)
    user = first(password_token: token)
    if (user and user.password_token_time + (60 * 60) > Time.now)
      user
    end
  end

end
