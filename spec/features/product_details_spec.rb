require 'rails_helper'

RSpec.feature "ProductDetails", type: :feature, js: true do
  pending "add some scenarios (or delete) #{__FILE__}"

  before :each do
    @category = Category.create! name: 'Apparel'
    #@category.products.create! (key:values) --> category has many products

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "See a product detail page" do
    # ACT
    visit root_path
    first('article.product').find_link("Details").click()
    sleep 0.3
    
    # DEBUG / VERIFY
    save_screenshot
    expect(page).to have_content('Name')
    expect(page).to have_content('Description')
  end

end
