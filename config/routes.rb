Rails.application.routes.draw do
  resources :images, only: :create
  resources :gcms, only: :create
end
