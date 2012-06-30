TickTock::Application.routes.draw do

  namespace :cpanel do
    get "dashboard/index"
  end

  #match '/wall' => 'moments#wall', :via => :get, :as => 'moments_wall'
  #match 'moments/get_random' => 'moments#get_random', :via => :get, :as => 'moments_get_random'
  resources :moments do
    get 'page/:page', :action => :index, :on => :collection
    get 'wall', :action => :wall, :on => :collection
    get 'get_random', :action => :get_random, :on => :collection
  end

  get "/about", :to => 'home#about', :as => 'about'
  root :to => 'home#index'

  devise_for :users
  devise_scope :users do
    resource :registration,
             only: [:new, :create, :edit, :update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration do
      get :cancel
    end
  end

end
