Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root "root#show"

  resources :colles, only: [:index]

  resources :documents, only: [] do
    collection do
      get "download/:download_id", action: :download, as: :download
    end
  end

  namespace :user do
    resources :profile, only: [:index]
    resources :informations, only: [:index]
    resources :downloads, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      resources :documents, only: [:create]
    end
  end
end
