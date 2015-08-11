FinanceApp::Application.routes.draw do

  ############################################
  ########### finance managers
  get 'news/delete_record', :to=>'news#delete_record'
  post 'news/batch_update', :to=>'news#batch_update'
  resources :news

  get 'companies/delete_record', :to=>'companies#delete_record'
  post 'companies/batch_update', :to=>'companies#batch_update'
  resources :companies

  get 'products/delete_record', :to=>'products#delete_record'
  post 'products/batch_update', :to=>'products#batch_update'
  resources :products

  get 'finance_organizations/delete_record', :to=>'finance_organizations#delete_record'
  post 'finance_organizations/batch_update', :to=>'finance_organizations#batch_update'
  resources :finance_organizations

  get 'categories/delete_record', :to=>'categories#delete_record'
  post 'categories/batch_update', :to=>'categories#batch_update'
  resources :categories

  resources :product_histories

  ##############################
  get 'sessions/logout', :to=>'sessions#logout'
  resources :sessions

  get 'sensitive_words/delete_record', :to=>'sensitive_words#delete_record'
  resources :sensitive_words

  resources :users

  ############################################
  ########### finance api
  namespace :api, :controller=>'api' do
    match 'finance_news_list', :to=>'/api#finance_news_list', via: [:get, :post]
    match 'finance_info', :to=>'/api#finance_info', via: [:get, :post]
  end

end
