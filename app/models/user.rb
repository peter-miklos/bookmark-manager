require 'bcrypt'
require 'dm-validations'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, required: true, format: :email_address,
      messages: {
        presence: "Email is mandatory",
        format: "Doesn't look like an email address"
      }
  property :password, BCryptHash

  attr_accessor :password_confirmation
  attr_reader :password

  validates_confirmation_of :password,
    :message => 'Password mismatch'
end
