Slothrop::Application.routes.draw do
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  mount Ckeditor::Engine => '/ckeditor'

  resources :consignment_items

  resources :consigners

  mount Ckeditor::Engine => "/ckeditor"
  resources :events
  resources :collections
  resources :podcasts
  resources :records
  resources :musiccategories

  resources :reviews
  resource :search

  resources :consignment_items
  resources :posts
  match '/page/:id' => "staticpages#show", :as => :pages
  resources :inventories do
    member do
      get :consigned
    end
    collection do
      get :featured
    end
  end

  resources :editions
  resources :categories
  resources :publishers

  get "ajax/books"

  get "ajax/users"

  get "ajax/creators"

  match '/auth/:provider/callback' => 'authentications#create'
  match '/admin/' => 'admin/books#home'
  devise_for :users,  :controllers => { :registrations => "registrations" }
  resources :authentications

  resources :books

  resources :creators
  resources :users
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  root :to => 'posts#index' 
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
    namespace :admin do


      resources :bookbuys

      # Directs /admin/products/* to Admin::ProductsController
      # (app/controllers/admin/products_controller.rb)
      resources :books do
        resources :editions
        resources :reviews
        collection do
          get :query
          match ':query/query' => "books#query"
          match ':amazon_code/choose' => "books#choose"
        end
        member do 
          post :tag
        end
      end
      
      resources :carousels
      
      resources :categories
      resources :musiccategories
      
      resources :consigners do
        member do
          get :sales_history
          get :new_book
          get :new_record
          get :new_item
          get :edit_book
          get :collect_payments
        end
        resources :consignment_items
      end
      
      resources :consingment_items
    
      resources :creators
      resources :editions 

      resources :expenses do
        collection do 
          get :csv_export
        end
      end
      
      resources :events
      
      resources :inventories do
        member do
          get :audit
          get :audit_item
          get :toggle_featured
          post :adjustprice
        end
        collection do 
          get :audit
          post :audit_query
          match ':edition_id/new_from_edition' => "inventories#new"
        end
        resources :categories do
          collection do
            get :unset
          end
          get :set_category
        end
      end

      
      resources :paymenttypes
      # resources :payments
      resources :podcasts
      resources :posts
      resources :records
      
      resources :reports do
        collection do
          get :undiscovered
          get :phantom_editions
          get :sold_books
          get :staff
          post :inventory_acquisition
          post :daily_sales
          post :expenses_cgs
          post :credit_sales
          post :consigner_report
        end
      end
      
      resources :reviews
      
      resources :sales do  
        resources :inventories do
          get :add_to_cart
          get :remove_from_cart
        end
        
        resources :consignment_items do
          get :add_to_cart_consignment
          get :remove_from_cart_consignment
        end
        
        resources :vouchers do
          get :remove_from_cart
        end
        
        collection do
          get :csv_export
          get :open
          resources :inventories do
            get :start_cart
          end
          resources :consignment_items do
            get :start_from_consignment
          end
          post :query
        end
        
        member do
          get :query
          post :add_comment
          post :apply_discount
          get :complete
        end
              
        resources :payments
      end
      
      resources :staticpages
      resources :tags
      resources :users
      resources :vouchers do
        collection do
          get :start_cart
        end
      end
    end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
