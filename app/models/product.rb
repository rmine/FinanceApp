class Product < ActiveRecord::Base
  include PublicConstant
  has_many :product_histories
  has_many :news, -> {where state:PublicConstant::ST_APPROVED}
  belongs_to :company
  belongs_to :category

  validates_with PublicConstant::GoodnessValidator, fields: {:name=>"产品名称",
                                                             :ios_downloadurl=>"ios下载",
                                                             :android_downloadurl=>"android下载",
                                                             :establishmented_at=>"立项时间"
                                                  }

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? PublicConstant::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end