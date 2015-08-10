class FinanceOrganization < ActiveRecord::Base
  include PublicConstant
  has_many :news_finance_organizations, -> {where state:PublicConstant::ST_APPROVED}, foreign_key: "organization_id"

  PERSONAL_ORG = 1
  GROUP_ORG = 0

  ORG_TYPE = {
      "个人"=>PERSONAL_ORG,
      "组织"=>GROUP_ORG
  }

  validates_with PublicConstant::GoodnessValidator, fields: {:is_person=>"机构类型",
                                                             :name=>"机构名称",
                                                             :description=>"描述"}

  def self.scope_paginate(params)
    page = params[:page].blank? ? 1 : params[:page]
    page_size = params[:page_size].blank? ? 20 : params[:page_size]
    state = params[:state].blank? ? PublicConstant::ST_ALL : params[:state]
    self.by_state(state).paginate(:page => page, :per_page => page_size).order_created_desc
  end
end