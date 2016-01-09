Rails.application.routes.draw do
  resources :images, only: :create
end
