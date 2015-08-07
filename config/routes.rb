FinanceApp::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  #root :to=> "home#index"
  get 'api', :to=>'api#index'

  match 'api/register_user', :to=>'api#register_user', via: [:get,:post]

  match 'api/register', :to=>'api#register',via: [:get,:post]

  match 'api/login', :to=>'api#login',via: [:get,:post]

  match 'api/update_password', :to=>'api#update_password',via: [:get,:post]

  get 'api/my_journey', :to=>'api#my_journey'

  get 'api/contents_list', :to=>'api#contents_list'

  get 'api/contents_essence_list', :to=>'api#contents_essence_list'

  get 'api/contents_cross_list', :to=>'api#contents_cross_list'

  get 'api/content_comments_list', :to=>'api#content_comments_list'

  get 'api/my_collects_list', :to=>'api#my_collects_list'

  get 'api/collect_content', :to=>'api#collect_content'
  get 'api/uncollect_content', :to=>'api#uncollect_content'

  get 'api/praise_content', :to=>'api#praise_content'

  match 'api/submit_comment', :to=>'api#submit_comment', via: [:get, :post]

  match 'api/feedbacks', :to=>'api#feedbacks', via: [:get, :post]

  post 'api/upload_avatar', :to=>'api#upload_avatar'


  ##############################
  get 'sessions/logout', :to=>'sessions#logout'
  resources :sessions

  get 'contents/delete_record', :to=>'contents#delete_record'
  get 'contents/test_qiniu', :to=>'contents#test_qiniu'
  post 'contents/upload_pic', :to=>'contents#upload_pic'
  post 'contents/batch_update', :to=>'contents#batch_update'
  resources :contents

  get 'sensitive_words/delete_record', :to=>'sensitive_words#delete_record'
  resources :sensitive_words

  resources :users
  resources :feedbacks

  ############################################
  ########### finance api
  get 'api/finance_news_list', :to=>'api#finance_news_list'
  get 'api/finance_info', :to=>'api#finance_info'

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


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
