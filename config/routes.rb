Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users

  resources :expenses do
    collection do
      get 'category/:category', to: 'expenses#category', as: 'category'
      get 'reports/index'
    end
  end
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'expenses#index'
end
