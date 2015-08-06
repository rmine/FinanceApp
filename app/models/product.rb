class Product < ActiveRecord::Base
  has_many :product_histories
  has_many :news
  belongs_to :company
end