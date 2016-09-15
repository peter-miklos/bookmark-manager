require 'spec_helper'

feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    sign_up
    expect(page.status_code).to eq(200)
    expect(User.all.size).to eq 1
    expect(page).to have_content('Welcome, testuser1@john.com')
    expect(User.first.email).to eq('testuser1@john.com')
  end

  scenario 'Passwords must match' do
    sign_up(password_confirmation: 'my_secret_password2')
    expect(User.all.size).to eq 0
    expect(current_path).to eq '/users/new'
    expect(page).to have_content 'Password does not match the confirmation'
    expect(find_field('email').value).to eq 'testuser1@john.com'
  end

  scenario 'users cannot sign up with empty email address' do
    sign_up(email: '',)
    expect(page).to have_content 'Email must not be blank'
    expect(User.all.size).to eq 0
  end

  scenario 'users cannot sign up with invalid email address' do
    sign_up(email: 'abc')
    expect(page).to have_content 'Email has an invalid format'
    expect(User.all.size).to eq 0
  end

  scenario 'users cannot sign up twice' do
    sign_up
    sign_up
    expect(User.all.size).to eq 1
    expect(page).to have_content 'Email is already taken'
  end
end

feature "User sign in" do

  scenario "user can sign in with proper credintials" do
    sign_up
    sign_up(email: 'testuser2@john.com')
    sign_in(email: 'testuser1@john.com', password: 'my_secret_password')
    expect(page).to have_content("Welcome, testuser1@john.com")
  end

  scenario "user cannot sign in with wrong email and/or password" do
    sign_up
    sign_in(email: 'testuser2@john.com')
    expect(page).to have_content("Username or password is not correct")
  end

end

feature 'User sign out' do

  scenario 'user can sign out and goodbye message is shown' do
    sign_up
    sign_in
    click_button 'Sign out'

    expect(page).to have_content 'Goodbye!'
    expect(current_path).to eq '/links'
  end
end

feature 'password recovery' do

  scenario "after requesting password reset, user is asked to check the inbox" do
    request_password_reset
    expect(page).to have_content "Please check your inbox"
  end

  scenario 'valid user can request password reset token' do
    request_password_reset
    expect(User.first.password_token).not_to eq nil
  end

  scenario "allows user to use the token within one hour" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    Timecop.travel(60*60*2) do
      visit "/users/password_reset?token=#{user.password_token}"
      expect(page).to have_content "Your token is invalid"
    end
  end

  scenario "asks for new password if the token is valid" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    visit "/users/password_reset?token=#{user.password_token}"
    user = User.first(email: 'testuser1@john.com')
    expect(page).to have_content("Please enter your new password")
  end

  scenario "lets user to enter new password with valid token" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    visit "/users/password_reset?token=#{user.password_token}"
    fill_in :password, with: "my_secret_password2"
    fill_in :password_confirmation, with: "my_secret_password2"
    click_button "Submit"
    expect(page).to have_content "Sign In"
  end

  scenario "lets user sign in after password reset" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    visit "/users/password_reset?token=#{user.password_token}"
    fill_in :password, with: "my_secret_password2"
    fill_in :password_confirmation, with: "my_secret_password2"
    click_button "Submit"
    sign_in(password: "my_secret_password2")
    expect(page).to have_content("Welcome, testuser1@john.com")
  end

  scenario "lets user know if the passwords do not match" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    visit "/users/password_reset?token=#{user.password_token}"
    fill_in :password, with: "my_secret_password2"
    fill_in :password_confirmation, with: "my_secret_password3"
    click_button "Submit"
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "after completed password reset token becomes invalid" do
    request_password_reset
    user = User.first(email: 'testuser1@john.com')
    visit "/users/password_reset?token=#{user.password_token}"
    fill_in :password, with: "my_secret_password2"
    fill_in :password_confirmation, with: "my_secret_password2"
    click_button "Submit"
    visit "/users/password_reset?token=#{user.password_token}"
    expect(page).to have_content("Your token is invalid")
  end

end
