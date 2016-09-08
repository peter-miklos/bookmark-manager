require 'spec_helper'

feature 'let a user sign up' do
  scenario 'a user signs in on the /sign_up page' do
    add_email_and_password
    fill_in('password_confirmation', with: 'ilovecoffeealot')
    click_button('Sign Up')
    expect(page).to have_content('Welcome joseph@coffeenutcase.com')
    expect(User.first.email).to eq('joseph@coffeenutcase.com')
    expect(User.count).to eq(1)
  end

  scenario "user tries to sign up with mismatching passwords" do
    add_email_and_password
    fill_in('password_confirmation', with: 'iloveteaalot')
    click_button('Sign Up')
    expect(page).to have_content('Password mismatch')
    expect(User.count).to eq 0
    expect(find_field('email').value).to eq('joseph@coffeenutcase.com')
  end

  scenario 'user tries to sign up with no email address' do
    add_password_twice
    click_button('Sign Up')
    expect(User.count).to eq 0
    expect(page).to have_content('Email must not be blank')
  end

  scenario 'user tries to sign up with a non valid email address' do
    add_password_twice
    fill_in('email', with: 'joseph@coffeenutcase')
    click_button('Sign Up')
    expect(User.count).to eq 0
    expect(page).to have_content("Email has an invalid format")
  end

  scenario 'user sign up with existing email' do
    2.times do
      add_email_and_password
      fill_in('password_confirmation', with: 'ilovecoffeealot')
      click_button('Sign Up')
    end
    expect(User.count).to eq 1
    expect(page).to have_content("Email is already taken")
  end


end
