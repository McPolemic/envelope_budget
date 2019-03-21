Rails.application.routes.draw do
  resources :budgets, only: [:show]
  resources :messages, only: [:create]
end
