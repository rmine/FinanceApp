class News < ActiveRecord::Base
  include PublicConstant
  has_many :news_finance_organizations
  belongs_to :product

  accepts_nested_attributes_for :news_finance_organizations, allow_destroy: true

  scope :order_finance_asc, ->{order('finance_at asc')}

  FINANCE_ROUND_HASH = {
      "天使" => "天使",
      "Pre-A" => "Pre-A",
      "A" => "A",
      "A+" => "A+",
      "B" => "B",
      "C" => "C",
      "D" => "D",
      "E" => "E"
  }

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? News::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end