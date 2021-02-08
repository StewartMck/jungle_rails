class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all
  end

  def show
    @items = LineItem.joins(:product).where({order_id: params[:id]}).select(:order_id, :product_id, :name, :quantity, :item_price_cents, :total_price_cents)
    @order = Order.find(params[:id])
  end

  def discount?(cost_price, paid_price)
    if cost_price.instance_of? (Array)
      total_cost = cost_price.reduce(0) { |sum, n| sum + n}
      return total_cost - paid_price.to_i
    else
    return cost_price - paid_price.to_i
  end
end
helper_method :discount?

end
