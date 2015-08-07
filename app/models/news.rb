class News < ActiveRecord::Base
  include PublicConstant
  has_many :news_finance_organizations
  belongs_to :product

  scope :order_finance_asc, ->{order('finance_at asc')}

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? News::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end