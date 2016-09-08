require 'spec_helper'

feature 'let a user sign up' do
  scenario 'a user signs in on the /sign_up page' do
    visit '/sign_up'
    fill_in('email', with: 'joseph@coffeenutcase.com')
    fill_in('password', with: 'ilovecoffeealot')
    fill_in('password_confirmation', with: 'ilovecoffeealot')
    click_button('Sign Up')
    expect(page).to have_content('Welcome joseph@coffeenutcase.com')
    expect(User.first.email).to eq('joseph@coffeenutcase.com')
    expect(User.count).to eq(1)
  end

  scenario "user tries to sign up with mismatching passwords" do
    visit '/sign_up'
    fill_in('email', with: 'joseph@coffeenutcase.com')
    fill_in('password', with: 'ilovecoffeealot')
    fill_in('password_confirmation', with: 'iloveteaalot')
    click_button('Sign Up')
    expect(page).to have_content('Password mismatch')
    expect(User.count).to eq 0
    expect(find_field('email').value).to eq('joseph@coffeenutcase.com')
  end


end
