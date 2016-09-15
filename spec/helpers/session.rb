module SessionHelpers

  def sign_up(email: 'testuser1@john.com',
              password: 'my_secret_password',
              password_confirmation: 'my_secret_password')
    visit '/users/new'
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end

  def sign_in(email: 'testuser1@john.com',
              password: 'my_secret_password')
    visit '/sessions/new'
    fill_in(:email, with: email)
    fill_in(:password, with: password)
    click_button 'Sign in'
  end

  def request_password_reset(email: 'testuser1@john.com')
    sign_up
    click_button 'Sign out'
    visit '/sessions/new'
    click_button 'Forgot my password'
    fill_in :email, with: email
    click_button "Reset password"
  end
end
