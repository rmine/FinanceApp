class NewsFinanceOrganization < ActiveRecord::Base
  belongs_to :finance_organization, foreign_key: "organization_id"

  FINANCE_TYPE_MAIN = 1
  FINANCE_TYPE_FOLLOW = 0

  FINANCE_TYPE_HASH = {
      "主投"=>FINANCE_TYPE_MAIN,
      "跟投"=>FINANCE_TYPE_FOLLOW
  }
end