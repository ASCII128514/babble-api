# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    p params[:room]
    puts "\n\n\n\n\n"
    # add a subscribers thing to the db
    # para = JSON.parse(params)
    token = params[:token]
    openid = decode(token)
    p openid
    puts "run!!\n\n\n\n"
    @user = User.find_by(openid: openid[:token])
    # find the game and add a join table between the user and the game
    @game = Game.find(params[:room])

    @subscriber = Subscriber.new
    @subscriber.game = @game
    @subscriber.user = @user
    @subscriber.save

    stream_from "game_channel_#{params[:room]}"
    # GameChannel.broadcast_to(
    #   "game_channel_#{params[:room]}",
    #   title: 'new subscribe',
    #   body: {
    #     players: @game.users
    #   }
    # )

    ActionCable.server.broadcast("game_channel_#{params[:room]}",
                                 type: 'users',
                                 players: @game.users)
  end

  def unsubscribed
    # remove the subscriber join table if the user close the connection
  end

  private

  def decode(token)
    # decode the jwt token to the open id
    t = JWT.decode token, nil, false
    t[0]
  end
end
