require 'spec_helper'

feature 'Let the user sign in' do

  let!(:user) do
    User.create(email: 'testuser@testdomain.com',
                password: 'test001',
                password_confirmation: 'test001')
  end

  scenario 'user is able to sign in and see an welcome message' do
    sign_in(email: user.email, password: 'test001')
    expect(page).to have_content('Welcome testuser@testdomain.com')
  end

  scenario 'user tries to login with with wrong password' do
    sign_in(email: user.email, password: 'test111')
    expect(page).to have_content('Email and/or password is not correct')
  end

end
