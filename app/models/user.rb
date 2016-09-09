require_relative '../data_mapper_setup'
require 'bcrypt'
require 'securerandom'

class User
  include DataMapper::Resource

  property :id,     Serial
  property :email,  String, :required => true, :unique => true
  property :password_digest, Text
  property :password_token, Text

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
    self.save
  end

end
