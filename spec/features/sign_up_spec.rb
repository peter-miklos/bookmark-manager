require 'spec_helper'

feature 'let a user sign up' do
  scenario 'a user signs in on the /sign_up page' do
    visit '/sign_up'
    fill_in('email', with: 'joseph@coffeenutcase.com')
    fill_in('password', with: 'ilovecoffeealot')
    click_button('Sign Up')
    expect(page).to have_content('Welcome joseph@coffeenutcase.com')
    expect(User.first.email).to eq('joseph@coffeenutcase.com')
    expect(User.count).to eq(1)
  end


end
