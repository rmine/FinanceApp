json.result_code @result_code
json.result_msg @result_msg
if @news.present? && @result_code == 1
  json.results do
    json.id @news.id
    json.title @news.title
    json.product_name @news.product.name
    json.finance_round @news.finance_round
    json.amount @news.amount
    json.company @news.product.company.name
    json.company_value_amount @news.product.company.value_amount
    json.company_published_at @news.product.company.published_at.strftime('%Y-%m-%d')
    json.company_founder @news.product.company.founder
    json.finance_at @news.finance_at.strftime('%Y-%m-%d %H:%M:%S')
    json.finance_organizations @news.news_finance_organizations, :id, :news_id, :organization_id, :finance_type
    json.finance_details @finance_details do |detail|
      json.id detail.id
      json.finance_round detail.finance_round
      json.amount detail.amount
      json.finance_at detail.finance_at.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
