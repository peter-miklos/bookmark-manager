require 'spec_helper'

describe User do

  let!(:user) do
    User.create(email: 'testuser@testdomain.com',
                password: 'test001',
                password_confirmation: 'test001')
  end

  it "authenticate user if proper credentials are added" do
    logged_in_user = User.authenticate(user.email, 'test001')
    expect(user).to eq logged_in_user
  end
end
