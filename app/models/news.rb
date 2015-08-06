class News < ActiveRecord::Base
  has_many :news_finance_organizations
  belongs_to :product

end