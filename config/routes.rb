Rails.application.routes.draw do
  resources :blog, only: [:index, :show]
end
