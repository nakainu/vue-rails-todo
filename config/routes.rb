Rails.application.routes.draw do
  root to: 'home#index'
  get '/list/:id',  to: 'home#index'
  get '/search',  to: 'home#index'

  namespace :api, format: 'json' do
    resources :lists, only: [:index, :create, :update]
    resources :todos, only: [:index, :create, :update, :destroy]
  end
end
