class Review < ActiveRecord::Base
  belongs_to :products

  validates :product_id, :user_id, :description, :rating, presence: true
end
