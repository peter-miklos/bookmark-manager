require 'spec_helper'

feature 'Create link' do
  scenario "add site's address and title to bookmark manager" do
    visit '/links/new'
    fill_in('title', with: 'Google')
    fill_in('url', with: 'http://www.google.com')
    click_button 'Add'

    expect(current_path).to eq '/links'

    within 'ul#links' do
      expect(page).to have_content 'Google'
    end
  end
end
