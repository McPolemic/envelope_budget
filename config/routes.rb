Rails.application.routes.draw do
  resources :budgets, only: [:show]
  resources :messages, only: [:create]
  post '/mail/', to: 'mail#create', as: 'mail'
end
