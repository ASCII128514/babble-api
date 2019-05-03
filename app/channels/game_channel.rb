# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    p params[:room]
    puts "\n\n\n\n\n"
    # add a subscribers thing to the db
    # para = JSON.parse(params)
    token = params[:token]
    openid = decode(token)
    p openid['token']
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
    puts "run!!\n\n\n\n"
    # filter the people that is not in the room
    u.each do |user|
      puts user.id
      puts 'inside loop'
      unless ids.include?(user.id)
        ids << user.id
        @users << user
      end
    end
    p ids
    p @users
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
    p params[:token]
    puts "in unsubscribe\n\n\n\n\n\n\n\n"
    token = params[:token]
    openid = decode(token)
    @user = User.find_by(openid: openid[:token])
    sub = @user.subscribers.find { |x| x.game.id == params[:room] }
    p sub
    puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nn\n\n\n\n\n\n"
    sub.destroy
  end

  private

  def decode(token)
    # decode the jwt token to the open id
    t = JWT.decode token, nil, false
    t[0]
  end
end
