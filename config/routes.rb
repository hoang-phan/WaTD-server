Rails.application.routes.draw do
  resources :images, only: [:create, :show, :update]
  resources :gcms, only: :create
end
