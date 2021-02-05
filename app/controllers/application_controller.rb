class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def cart
    @cart ||= cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
  end
  helper_method :cart

  def enhanced_cart
    @enhanced_cart ||= Product.where(id: cart.keys).map {|product| { product:product, quantity: cart[product.id.to_s], sales_discount: get_discount_percentage? } }
  end
  helper_method :enhanced_cart

  def cart_subtotal_cents
    enhanced_cart.map {|entry| entry[:product].price_cents * entry[:quantity]}.sum
  end
  helper_method :cart_subtotal_cents

  def update_cart(new_cart)
    cookies[:cart] = {
      value: JSON.generate(new_cart),
      expires: 10.days.from_now
    }
    cookies[:cart]
  end

  def find_sale
    @active_sale = Sale.active.first
  end
  helper_method :find_sale


  def get_discount_percentage?
    if find_sale
    return @sales_discount = Sale.active.first[:percent_off].to_f / 100
    else
      return 1
    end
  end
  helper_method :get_discount_percentage?

  def get_discount_price?(price)
    if find_sale
    discount_percentage = Sale.active.first[:percent_off].to_f / 100
    discount_value = price * discount_percentage
    return @discount_price = price - discount_value
    else
      return price
    end
  end
  helper_method :get_discount_price?
end
