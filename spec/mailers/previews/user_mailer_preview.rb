# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/receipt_email
  def receipt_email

    @category = Category.new({ name: 'Test Category' })
    @category.save!

    @product1 = Product.create(
      name: 'Test Product 1',
      price_cents: 100,
      quantity: 1,
      category_id: @category.id
    )
    @product2 = Product.create(
      name: 'Test Product 2',
      price_cents: 100,
      quantity: 1,
      category_id: @category.id
    )
    @order = Order.new({
                         email: 'test@email.com',
                         total_cents: 30000,
                         stripe_charge_id: 1
                       })
  @order.line_items.new({
                        product: @product1,
                        quantity: 1,
                        item_price: 100,
                        total_price: 100
                      })
@order.line_items.new({
                        product: @product2,
                        quantity: 1,
                        item_price: 200,
                        total_price: 200
                      })

    UserMailer.receipt_email(@order)

  end

end
