class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all
  end

  def show
    @items = LineItem.joins(:product).where({order_id: params[:id]}).pluck(:product_id, :name, :quantity, :item_price_cents, :total_price_cents)
  end

end
