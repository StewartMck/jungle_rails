require 'rails_helper'

RSpec.feature "UserLogins", type: :feature, js:true do

  before :each do
  @user = User.create!(
    first_name: 'First Name',
    last_name: 'Last Name',
    email: 'first@email',
    password: '1234',
    password_confirmation: '1234'
  )
end

  scenario "User Login" do
    # ACT
  visit root_path
  # puts page.html
  find("#navbar > ul.nav.navbar-nav.navbar-right > li:nth-child(3) > a").click()
  sleep 0.3
  save_screenshot

  fill_in('Email Address', :with => 'first@email')
  fill_in('Password', :with => '1234')
  sleep 0.3
  save_screenshot

  find_button("Login").click()
  sleep 0.3
  save_screenshot

  # DEBUG / VERIFY
 expect(page).to have_content 'Logout'
  end

end
