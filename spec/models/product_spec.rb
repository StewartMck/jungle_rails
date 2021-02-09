require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @category = Category.new({ name: 'Test Category' })
    @category.save!

    @product = Product.new({
                             name: 'Test Product',
                             price_cents: 100,
                             quantity: 1,
                             category_id: @category.id
                           })
  end

  describe 'Validations' do
    context 'with all valid attributes' do
      it 'validates successfully' do
        expect(@product).to be_valid
      end
    end
    context 'with 1 nil attribute' do
      it 'is not valid without a name' do
        @product.name = nil
        @product.save
        expect(@product.errors.full_messages).to include("Name can't be blank")
      end
      it 'is not valid without a price' do
        @product.price_cents = nil
        @product.save
        expect(@product.errors.full_messages).to include("Price can't be blank")
      end
      it 'is not valid without a quantity' do
        @product.quantity = nil
        @product.save
        expect(@product.errors.full_messages).to include("Quantity can't be blank")
      end
      it 'is not valid without a category' do
        @product.category_id = nil
        @product.save
        expect(@product.errors.full_messages).to include("Category can't be blank")
      end
    end
  end
end
