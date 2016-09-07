require "data_mapper"
require "dm-postgres-adapter"
require "dm-validations"

class User

  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String, required: true, format: :email_address, unique: true,
    messages: {
      is_unique: "We already have that email",
      format: "Doesn't look like an email address",
      presence: "Email is required."
    }
  property :password_digest, BCryptHash

  attr_accessor :password_confirmation
  attr_reader :password

  validates_confirmation_of :password

  # this will store both the password and the salt
  # It's Text and not String because String holds
  # only 50 characters by default
  # and it's not enough for the hash and salt

  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by bcrypt,
  # has both the password hash and the salt. We save it to the
  # database instead of the plain password for security reasons.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end


end
