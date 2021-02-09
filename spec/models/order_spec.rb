require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Reduce stock after order create' do
    before :each do
      @category = Category.new({ name: 'Test Category' })
      @category.save!

      @product1 = Product.create!(
        name: 'Test Product 1',
        price_cents: 100,
        quantity: 1,
        category_id: @category.id
      )
      @product2 = Product.create!(
        name: 'Test Product 2',
        price_cents: 100,
        quantity: 1,
        category_id: @category.id
      )
      @order = Order.new({
                           email: 'test@emai.com',
                           total_cents: 100,
                           stripe_charge_id: 1
                         })
    end
    context 'with all two products in order' do
      it 'deducts quantity from products based on their line item quantities' do
        @order.line_items.new({
                                product: @product1,
                                quantity: 1,
                                item_price: @product1.price,
                                total_price: @product1.price
                              })
        @order.line_items.new({
                                product: @product2,
                                quantity: 1,
                                item_price: @product2.price,
                                total_price: @product2.price
                              })

        @order.save!
        @product1.reload
        @product2.reload

        expect(@product1).to have_attributes(quantity: 0)
        expect(@product1).to have_attributes(quantity: 0)
      end
    end
    context 'with 1 products in order' do
      it 'does not deduct quantity from products that are not in the order' do
        @order.line_items.new({
                                product: @product1,
                                quantity: 1,
                                item_price: @product1.price,
                                total_price: @product1.price
                              })

        @order.save!
        @product1.reload

        expect(@product1).to have_attributes(quantity: 0)
        expect(@product2).to have_attributes(quantity: 1)
      end
    end
  end
end
