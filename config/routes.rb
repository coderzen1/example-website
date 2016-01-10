Rails.application.routes.draw do

  devise_for :restaurant_owners, controllers: { registrations: "registrations" }
  devise_for :super_users

  namespace :admin, module: "super_users" do
    resources :activations, only: [:index] do
      member do
        post :approve, :reject, :delete_owner
      end
    end
    resources :super_users
    resources :restaurant_owners
    resources :reported_photos, only: [:index] do
      member do
        post :approve, :remove, :remove_tag
      end
    end

    resources :users, only: [:index, :destroy] do
      member do
        get :lock, :restore, :unlock
      end
    end
  end

  namespace :restaurants, module: "restaurant_owners" do
    root to: "basic_info#index"
    resources :signup, only: [:update, :show]
    resources :restaurant, only: [:update, :edit]
    resources :general_info, only: [:update, :edit]
    resources :basic_info, only: [:index, :new, :create, :edit]
    resources :location, only: [:index, :new, :edit, :update]
    resources :menu, only: [:index, :new, :create]
    resources :photos, only: [:index, :new, :create] do
      resource :photo_report, only: [:create], as: 'report'
    end

    get 'settings', to: 'settings#index'
    resources :tag_report_actions, only: [:update]
    resources :tags, only: [:index] do
      member do
        get :photos, to: 'tag_photos#index'
      end
      resource :tag_report, only: [:create], as: 'report'
    end
    
    get 'settings/edit_general_info', to: 'settings#edit_general_info'
  end

  mount RocketDocs::Engine => '/api-doc'
  root to: 'public#index'

  get 'about', to: 'public#about'
  get 'privacy_policy', to: 'public#privacy_policy'
  get 'terms_of_use', to: 'public#terms_of_use'

  get 'photos/discover', to: 'photos#discover'
  get 'photos/index', to: 'photos#index'

  get 'static-pages/opening-hours', to: 'static_pages#opening_hours'
  get 'static-pages/add-specialty', to: 'static_pages#add_specialty'


  resources :newsletter_subscriptions, only: [:create]
  devise_for :users

  namespace :api do
    api version: 1, module: "v1", allow_prefix: 'v', defaults: { version: 'v1' } do
      resources :users, only: [:create, :show] do
        collection do
          post :login
          post 'login/oauth', action: :oauth_login
          get  :feed
          put :update
          put :update_password
          get :disliked_tags, only: [:index], to: 'disliked_user_tags#index'
          delete :destroy
        end

        member do
          get    :followers
          get    :following
          get    :restaurants, only: [:index], to: 'favorite_restaurants#index'
          get    :favorite_tags, only: [:index], to: 'favorite_user_tags#index'
          get    :favorite_photos, to: 'user_photos#index'
          resource :follow, only: [:create, :destroy], controller: :relationships
        end
      end

      resources :photos, only: [:show, :index, :create, :update, :destroy] do
        member do
          resource  :favor,    controller: :favorite_photos, only: [:create, :destroy]
          resources :fans, controller: :favorite_photos, only: [:index]
          resources :reports, controller: :photo_reports, only: [:create] do
            delete :destroy, on: :collection
          end
        end
        collection do
          get :discover
        end
      end

      resources :tags, only: [:index] do
        member do
          get :photos, to: 'tag_photos#index'
        end
      end

      resources :restaurants, only: [:index, :show, :create] do
        collection do
          get :map_pois
        end
        member do
          get :feed
          get :tags, to: 'restaurant_tags#index'
        end
      end

      resources :favorite_user_tags, only: [:create] do
        collection do
          post :sync
          get :suggestions
        end
      end

      resources :disliked_user_tags, only: [:create] do
        collection do
          post :sync
          get :suggestions
        end
      end

      resources :favorite_restaurants, only: [:create, :destroy]
    end
  end
end
