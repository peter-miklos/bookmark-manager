module Helpers
  def sign_in(email:, password:)
    visit '/session/new'
    fill_in('email', with: email)
    fill_in('password', with: password)
    click_button('Sign In')
  end

  def sign_up(email: 'joseph@coffeenutcase.com',
              password: 'ilovecoffeealot',
              password_confirmation: 'ilovecoffeealot')
    visit '/sign_up'
    fill_in('email', with: email)
    fill_in('password', with: password)
    fill_in('password_confirmation', with: password_confirmation)
    click_button 'Sign Up'
  end
end
