require 'spec_helper'

feature 'let you filter tags for links' do
  before(:each) do
    Link.create(url: 'http://www.bbc.co.uk', title: 'BBC', tags:[Tag.first_or_create(name: 'news')])
    Link.create(url: 'http://www.buzzfeed.com', title: 'Buzzfeed', tags:[Tag.first_or_create(name: 'entertainment')])
    Link.create(url: 'http://www.bubblies.com', title: 'Bubblies', tags:[Tag.first_or_create(name: 'bubbles')])
    Link.create(url: 'http://www.fishing.com', title: 'Fishing', tags:[Tag.first_or_create(name: 'bubbles')])
  end

  scenario 'find links with bubble tag from list of links' do
    visit '/tags/bubbles'
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).not_to have_content('BBC')
      expect(page).not_to have_content('Buzzfeed')
      expect(page).to have_content('Bubblies')
      expect(page).to have_content('Fishing')
    end

  end
end
