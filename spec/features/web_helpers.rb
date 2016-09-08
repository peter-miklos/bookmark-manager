def add_link_no_submit
  visit '/links/new'
  fill_in('title', with: 'Codecademy')
  fill_in('url', with: 'www.codecademy.com')
end

def add_email_and_password
  visit '/sign_up'
  fill_in('email', with: 'joseph@coffeenutcase.com')
  fill_in('password', with: 'ilovecoffeealot')
end

def add_password_twice
  visit '/sign_up'
  fill_in('password', with: 'ilovecoffeealot')
  fill_in('password_confirmation', with: 'ilovecoffeealot')
end
