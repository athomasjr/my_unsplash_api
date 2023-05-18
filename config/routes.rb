Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        get :profile, on: :member
      end
      post '/login', to: 'auth#login'
    end
  end
end
