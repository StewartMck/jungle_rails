require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  before :each do
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
                         total_cents: 300,
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

  end

  describe "Order Receipt" do
    let(:mail) { UserMailer.receipt_email(@order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Jungle Order ##{@order.id} Receipt")
      expect(mail.to).to eq([@order.email])
      expect(mail.from).to eq(["no-reply@jungle.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@order.email)
    end
  end
end
