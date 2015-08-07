module NewsHelper

  def finance_organizations_list(params)
    main_orgs = []
    follow_orgs = []
    params.map{|param| main_orgs << param.finance_organization.name if param.finance_type == NewsFinanceOrganization::FINANCE_TYPE_MAIN}
    params.map{|param| follow_orgs << param.finance_organization.name if param.finance_type == NewsFinanceOrganization::FINANCE_TYPE_FOLLOW}
    ["<b>主投:</b><br/>",main_orgs.join(",<br/>"),"<br/><b>跟投:</b><br/>",follow_orgs.join(",<br/>")].join(" ").html_safe
  end

end