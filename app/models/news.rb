class News < ActiveRecord::Base
  include PublicConstant
  has_many :news_finance_organizations
  belongs_to :product

  scope :approved, -> {where(:state=>ST_APPROVED)}

  scope :by_state, proc {|state| where(:state=>state) if state.present? and  state.to_i > -1}

  scope :order_created_desc, ->{order('created_at desc')}
  scope :order_finance_asc, ->{order('finance_at asc')}

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    offset = params[:offset].blank? ? 0:params[:offset]
    self.approved.paginate(:page => page, :per_page => page_size).offset(offset).order_created_desc
  end
end