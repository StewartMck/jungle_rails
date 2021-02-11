class ReviewsController < ApplicationController

  before_action :require_login

  def create
    @product = Product.find params[:product_id]
    @review = @product.reviews.new(review_params)
    @review.user_id = current_user.id
    @review.save
    redirect_to :back
  end


  def destroy
    @review = Review.find params[:id]
    @review.destroy
    redirect_to :back, notice:
    "Category deleted"
  end

  private

  def review_params
    params.require(:review).permit(
      :description,
      :rating,
    )
  end

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

end
