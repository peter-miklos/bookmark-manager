require 'spec_helper'

feature 'let a user sign up' do
  scenario 'a user signs in on the /sign_up page' do
    sign_up
    expect(page).to have_content('Welcome joseph@coffeenutcase.com')
    expect(User.first.email).to eq('joseph@coffeenutcase.com')
    expect(User.count).to eq(1)
  end

  scenario "user tries to sign up with mismatching passwords" do
    sign_up(password_confirmation: 'iloveteaalot')
    expect(page).to have_content('Password mismatch')
    expect(User.count).to eq 0
    expect(find_field('email').value).to eq('joseph@coffeenutcase.com')
  end

  scenario 'user tries to sign up with no email address' do
    sign_up(email: '')
    click_button('Sign Up')
    expect(User.count).to eq 0
    expect(page).to have_content('Email must not be blank')
  end

  scenario 'user tries to sign up with a non valid email address' do
    sign_up(email: 'joseph@coffeenutcase')
    expect(User.count).to eq 0
    expect(page).to have_content("Email has an invalid format")
  end

  scenario 'user sign up with existing email' do
    2.times { sign_up}
    expect(User.count).to eq 1
    expect(page).to have_content("Email is already taken")
  end


end
