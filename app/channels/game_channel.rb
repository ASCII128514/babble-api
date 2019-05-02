# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{params[:room]}"
    puts params
    puts "\n\n\n\n\n\n runed!!!"
  end

  def unsubscribed; end
end
