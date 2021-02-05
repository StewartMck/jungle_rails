module SalesHelper
  def active_sale?
    Sale.active.any?
  end

  # def get_discount_price? price
  #   if active_sale?
  #   discount_percentage = Sale.active.first[:percent_off].to_f / 100
  #   discount_value = price * discount_percentage
  #   return @discount_price = price - discount_value
  #   else
  #     return 0
  #   end
  # end
end