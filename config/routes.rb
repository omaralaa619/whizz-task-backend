require 'sidekiq/web'
Rails.application.routes.draw do
   devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  mount Sidekiq::Web => "/sidekiq"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts do
  resources :comments, only: [:create, :update, :destroy, :index, :show]
end

resources :tags, only: [:index, :show, :create, :update, :destroy]

   resources :users, only: [] do
  resources :posts, only: [:index]
end

  # Defines the root path route ("/")
  # root "posts#index"
end
