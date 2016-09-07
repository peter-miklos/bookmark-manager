require 'spec_helper'

feature 'creating links' do
  scenario 'when submitting a form' do
    add_link_no_submit
    click_button('Add Link')
    expect(page.status_code).to eq 200
    expect(current_path).to eq '/links'

    within 'ul#links' do
      expect(page).to have_content('Codecademy')
    end
  end
end
