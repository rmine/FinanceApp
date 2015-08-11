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
  json.source_from news.source_from
  json.source_url news.source_url
  json.finance_organizations news.news_finance_organizations do |nfo|
    json.id nfo.id
    json.news_id nfo.news_id
    json.organization_name nfo.finance_organization.name
    json.finance_type nfo.finance_type
  end
end
json.page @page.to_i
json.page_size @page_size.to_i
json.total_page @total_page