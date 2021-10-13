require 'rails_helper'

RSpec.describe 'Weather forecast', type: :system do
  it 'shows a static text and search box upon landing on the index page' do
    visit root_path
    expect(page).to have_content('Weather forecast by zipcode')
  end

  it 'displays the weather forecast for a valid zipcode' do
    visit root_path
    fill_in 'zipcode', with: '90049'
    click_button 'Search'
    expect(page).to have_content("Today's weather in")
  end

  it 'displays an error for an invalid zipcode' do
    visit root_path
    fill_in 'zipcode', with: '00000'
    click_button 'Search'
    expect(page).to have_content("City not found")
  end

  it 'displays an error if search is done using an empty zipcode' do
    visit root_path
    click_button 'Search'
    expect(page).to have_content("Please enter a valid 5-digit zipcode")
  end
end