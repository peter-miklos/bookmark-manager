require 'spec_helper'

feature 'Let the user sign out' do

  let!(:user) do
    User.create(email: 'testuser@testdomain.com',
                password: 'test001',
                password_confirmation: 'test001')
  end

  scenario 'user is able to sign out and goodbye message is shown' do
    sign_in(email: user.email, password: 'test001')
    click_button('Sign Out')

    expect(page).to have_content('Goodbye!')
    expect(page).to_not have_content("Welcome testuser@testdomain.com")
  end
end
