require 'bcrypt'
require 'dm-validations'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, required: true, format: :email_address, unique: true
  property :password, BCryptHash

  attr_accessor :password_confirmation
  attr_reader :password

  validates_confirmation_of :password,
    :message => 'Password mismatch'

  def self.authenticate(email, login_password)
    user = last(email: email)
    if user && BCrypt::Password.new(user.password) == login_password
      user
    else
      nil
    end
  end
end
