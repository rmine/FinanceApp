class Company < ActiveRecord::Base
  include PublicConstant
  has_many :products, -> {where state:PublicConstant::ST_APPROVED}

  # validates_presence_of :name,:website,:value_amount,:founder,:state,:description,:published_at,:message => "不能为空"
  # validates :name,presence: true
  # validates_presence_of :website,:message => "公司网站不能为空"

  validates_with PublicConstant::GoodnessValidator, fields: {:name=>"公司名称",
                                                             :website=>"公司网站",
                                                             :value_amount=>"公司估值",
                                                             :founder=>"公司创始人",
                                                             :published_at=>"成立时间"
                                                  }

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? PublicConstant::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end