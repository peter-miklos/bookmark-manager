def add_link_no_submit
  visit '/links/new'
  fill_in('title', with: 'Codecademy')
  fill_in('url', with: 'www.codecademy.com')
end
