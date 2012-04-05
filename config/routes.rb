IteamApp::Application.routes.draw do
  resources :approvers

  resources :monitor_items
  resources :project_users
  resources :addr_books
  resources :monitor_actions

  get "monitor/index"

  resources :servers
  resources :addr_books
  resources :links
  resources :documents
  resources :members
  resources :teams
  resources :categories
  resources :announcements

  get "pages/home"
  get "pages/contact"
  get "faq/index"
  match '/pages/daprotocol' => 'pages#daprotocol'
  match '/faq/direct_link' => 'faq#direct_link'
  match '/faq/recent_posts' => 'faq#recent_posts'
  match '/faq/change_parent' => 'faq#change_parent'
  match '/faq/get_categories' => 'faq#get_categories'
  match '/faq/get_selections' => 'faq#get_selections'
  match '/faq/get_answer' => 'faq#get_answer'
  match '/faq/new_answer' => 'faq#new_answer'
  match '/faq/search' => 'faq#search'
  match '/faq/post-question' => 'faq#post_question'
  match '/faq/answer_feedback' => 'faq#answer_feedback'
  match '/category/my_categories' => 'categories#my_categories'
  match '/announcements/send_email' => "announcements#send_email"
  match 'answer/tup_change' => "answers#tup_change"
  match 'monitor_action/new' => "monitor_actions#new"
  match 'monitor_action/index' => "monitor_actions#index"
  match '/monitor_item/perform' => "monitor_items#perform"
  match '/project_users/send_request_email' => "project_users#send_request_email"
  match '/project_users/send_completed_email' => "project_users#send_completed_email"
  match '/project_users/send_approved_email' => "project_users#send_approved_email"
  match '/project_users/send_denied_email' => "project_users#send_denied_email"
  match '/get_sponsors' => "project_users#get_sponsors"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
