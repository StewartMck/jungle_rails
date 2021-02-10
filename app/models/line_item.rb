class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :product

  monetize :item_price_cents, numericality: true
  monetize :total_price_cents, numericality: true

  validate :stock_on_hand

  def stock_on_hand
    product = Product.find_by_id(self.product_id)
    if product.quantity < self.quantity
      errors.add(:base , "Stock Insufficient => #{product.name} stock on hand: #{product.quantity}")
    end
end

end
