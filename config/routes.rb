# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/login', to: 'users#login', as: :login
      post '/game', to: 'games#create', as: :game
      get '/game/:id/display', to: 'games#boardcast'
      get '/game/:id', to: 'games#show'
      get '/game/:id/question', to: 'games#question'

      # get all the users paired
      # need the room id and the user token so can just send the paired user to the server
      get 'game/:id/pair', to: 'games#pair'
    end
  end

  mount ActionCable.server, at: '/cable'
end
