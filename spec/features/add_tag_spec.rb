require 'spec_helper'

feature 'creating tags' do

  scenario 'add a single tag to a link' do
    add_link_no_submit
    fill_in('tag', with: 'coding')
    click_button('Add Link')
    link = Link.first
    expect(link.tags.map(&:name)).to include('coding')
  end
end
