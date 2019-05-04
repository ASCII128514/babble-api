# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/login', to: 'users#login', as: :login
      post '/game', to: 'games#create', as: :game
      get '/game/:id', to: 'games#show'
      get '/game/:id/question', to: 'games#question'
    end
  end

  mount ActionCable.server, at: '/cable'
end
