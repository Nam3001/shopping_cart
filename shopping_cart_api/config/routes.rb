Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      post "auth/refresh", to: "auth#refresh"
      get "auth/me", to: "auth#me"

      resources :products, except: %i[new edit]
      resources :categories, excep: %i[new edit] do
        member do
          get "products"
        end
      end

      resources :units, except: %i[new edit]
      resources :attributes, except: %i[new edit]
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
