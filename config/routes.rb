GradusAudio::Application.routes.draw do

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'log#index'

  match "/music" => "tracks#index", :as => :music_params_select
  match '/music/list' => 'tracks#filter',  :defaults => { :audio_type => "music" }, :as => :music_list

  match "/upload" => "tracks#upload", :as => :music_upload

  delete "tracks/delete" => "tracks#delete"

  get "logs" => 'log#index'
  get 'logs/:filename' => 'log#show', :format => 'html'

  match '/config' => 'AppConfig#edit', :method => :get
  match '/config/save' => 'AppConfig#update', :method => :post

  match '/adv' => 'adv#index'
  match '/adv/file-upload-wnd' => 'adv#file_upload_window'

  match '/adv/upload' => 'adv#upload'
  match '/adv/blocks' => 'adv#adv_blocks_list'
  match '/adv/block/refresh' => 'adv#refresh_adv_block'

  match '/filemanager/files' => 'adv#file_tree'

  match '/filemanager/create-folder' => 'FileUtils#create_folder', :as => :filemanager_create_folder

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
