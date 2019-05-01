# frozen_string_literal: true

WebsocketRails::EventMap.describe do
  namespace :api do
    namespace :v1 do
      # The :client_connected method is fired automatically when a new client connects
      subscribe :create, to: Api::V1::GamesController, with_method: :create
    end
  end
end
