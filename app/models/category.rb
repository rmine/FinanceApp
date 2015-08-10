class Category < ActiveRecord::Base
  include PublicConstant
  has_many :products, -> {where state:PublicConstant::ST_APPROVED}

  validates_with PublicConstant::GoodnessValidator, fields: {:name=>"类别名称",
                                                             :description=>"描述"
                                                  }

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? PublicConstant::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end