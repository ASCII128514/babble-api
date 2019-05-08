# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    # add a subscribers thing to the db
    # para = JSON.parse(params)
    token = params[:token]
    openid = decode(token)
    puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    @user = User.find_by(openid: openid['token'])
    # find the game and add a join table between the user and the game
    @game = Game.find(params[:room])

    @subscriber = Subscriber.new
    @subscriber.game = @game
    @subscriber.user = @user
    @subscriber.save
    ids = []
    @users = []
    u = @game.users
    # filter the people that is not in the room
    u.each do |user|
      unless ids.include?(user.id)
        ids << user.id
        @users << user
      end
    end
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
                                 players: @users)
  end

  def unsubscribed
    # remove the subscriber join table if the user close the connection
    # token = params[:token]
    # openid = decode(token)
    # p openid['token']
    # @user = User.find_by(openid: openid['token'])
    # sub = @user.subscribers.select { |x| x.game.id == params[:room] }
    # sub.each(&:destroy)
    # ids = []
    # @users = []
    # u = @game.users
    # # filter the people that is not in the room
    # u.each do |user|
    #   puts user.id
    #   puts 'inside loop'
    #   unless ids.include?(user.id)
    #     ids << user.id
    #     @users << user if user.openid != openid['token']
    #   end
    # end
    # ActionCable.server.broadcast("game_channel_#{params[:room]}",
    #                              type: 'users',
    #                              players: @users)
  end

  private

  def decode(token)
    # decode the jwt token to the open id
    t = JWT.decode token, nil, false
    t[0]
  end
end
