Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'companies#index'
  get 'companies', to: 'companies#index'
  patch 'company', to: 'companies#update'
end
