Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update] do
        member do
        get :profile
        get :photos
        end
      end
      resources :photos, only: [:create, :index, :destroy]
      post '/login', to: 'auth#login'
    end
  end
end
