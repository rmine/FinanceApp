class NewsFinanceOrganization < ActiveRecord::Base
  belongs_to :finance_organization, foreign_key: "organization_id"

  FINANCE_TYPE_MAIN = 1
  FINANCE_TYPE_FOLLOW = 0

  # validates_with PublicConstant::GoodnessValidator, fields: {:news_id=>"对应的融资新闻",
  #                                                            :organization_id=>"对应的融资机构",
  #                                                            :finance_type=>"对应的融资类型"}

  FINANCE_TYPE_HASH = {
      "主投"=>FINANCE_TYPE_MAIN,
      "跟投"=>FINANCE_TYPE_FOLLOW
  }
end