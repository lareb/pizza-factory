# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  resources :pizzas, only: [:index]
  resources :orders, only: %i[new create show] do
    member do
      get 'confirm'
    end
  end

  namespace :vendors do
    resources :inventories
    resources :pizzas
    resources :orders do
      member do
        get 'confirm'
      end
    end
    resources :crusts
    resources :toppings
    resources :sides
  end
end
