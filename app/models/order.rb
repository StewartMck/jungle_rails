class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true
 
  after_create do
    items = LineItem.where(order_id: id).all
    items.each do |item|
      product = Product.find(item.product_id)
      product.update(quantity: reduce_stock(product, item.quantity))
    end
  end

  private

  def reduce_stock(product, quantity)
    product.quantity.to_i - quantity
  end
end
