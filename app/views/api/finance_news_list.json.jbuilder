json.result_code 1
json.results @news do |news|
  json.id news.id
  json.title news.title
  json.product_name news.product.name
  json.finance_round news.finance_round
  json.amount news.amount
  json.company news.product.company.name
  json.company_value_amount news.product.company.value_amount
  json.finance_at news.finance_at.strftime('%Y-%m-%d %H:%M:%S')
  json.finance_organizations news.news_finance_organizations, :id, :news_id, :organization_id, :finance_type
end
json.page @page.to_i
json.page_size @page_size.to_i
json.left_page @left_page