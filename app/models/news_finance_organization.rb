class NewsFinanceOrganization < ActiveRecord::Base
  belongs_to :finance_organization, foreign_key: "organization_id"

end