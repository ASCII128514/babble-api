# frozen_string_literal: true

class Api::V1::GamesController < Api::V1::BaseController
  def create
    token = params[:tokens][:token]
    openid = decode(token)['token']

    user = User.where(openid: openid)[0]
    @game = Game.new(game_params)
    p @game
    # @game.find_partner_timer = game_params['find_partner_timer']
    # @game.selfie_timer = game_params['selfie_timer']
    # @game.question_timer = game_params['question_timer']
    # @game.round_number = game_params['round_number']
    p @game
    @game.status = 'start'
    @game.user = user
    p "\n\n\n\n\n\n"
    p @game
    @game.save
    # get the access token to get the QR code
    p @game
    p "\n\n\n\n\n\n\n"
    res = JSON.parse(RestClient.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{ENV['APPID']}&secret=#{ENV['SECRET_KEY']}"))
    # return the QR code to the user
    access_token = res['access_token']
    img = RestClient.post("https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=#{access_token}", { "scene": "room=#{@game.id}" }.to_json).body
    File.open('QRcode.png', 'wb') do |file|
      file << img
    end

    ob = `curl -X POST \
  -H "X-LC-Id: #{ENV['XLCID']}" \
  -H "X-LC-Key: #{ENV['XLCKEY']}" \
  -H "Content-Type: image/png" \
  --data-binary "@QRcode.png"  \
  https://qaxmtbr0.api.lncld.net/1.1/files/test.png`
    url = JSON.parse(ob)['url']
    render json: {
      url: url
    }

    # if @game.save
    #   send_message :create_success, game, namespace: :games
    # else
    #   send_message :create_fail, game, namespace: :games
    # end
  end

  def show
    @game = Game.find(params[:id])
    @users = @game.users
    render json: {
      game: @game,
      players: @users
    }
  end

  # generate a question for the paired user
  def question
    # get the question for every user
  end

  # def pair
  #   # use the game id and user token to generate the random pair of users
  #   # store the pair into the list so that one person won't get the same pair twice
  #   # clear all the pairs once everyone has a pair once

  #   # find the game and all its players, and the round
    # @game = Game.find(params[:id])
    # @players = @games.users
    # @round = params[:round]

  #   # find the current user
  #   token = params[:token]
  #   hash_openid = decode(token)
  #   openid = hash_openid['token']
  #   @user = User.find_by(openid: openid)

  #   # find whether the user is already assign to a pair
  #   @lists = @game.lists
  #   @list_all_rounds = @lists.find { |x| x.user.id == @user.id }
  #   @list = @list_all_rounds.find { |x| x.round_number == @round }
  #   @pairs = @list.pairs
  #   @pair_users = @pairs.map(&:users)

  #   # flatten the @pair_user
  #   @pair_users.flatten

  #   # return the pair if the user is already assigned to a pair

  #   if list.nil?
  #     # in this case, the user haven't pair with anyone
  #     # extract the current user from the player list
  #     other_players = @players.reject { |x| x.id == @user.id }

  #     # reject the users that this user have already paired with
  #     @paired_users = @list_all_rounds.map(&:pairs).flatten.map(&:user)

  #     # get the players that are only not paired with the user
  #     other_players = other_players.reject { |x| @paired_users.include?(x) }

  #     # shuffle the user list
  #     other_players = other_players.shuffle

  #     # create a list for this round for this round
  #     @this_round_list = List.new(round_number: @round)
  #     @this_round_list.game = @game
  #     @this_round_list.user = @user
  #     @this_round_list.save

  #     # generate three pairs if the there are only two more players
  #     if other_players.length == 2

  #       # also add those two players to each other
  #       a = other_players[0]
  #       b = other_players[1]

  #       other_players.each do |p|
  #         pair = Pair.new
  #         pair.user = p
  #         pair.list = @this_round_list
  #         pair.save

  #         # also add this user to those two players' lists
  #         other_player_list = List.new
  #         other_player_list.user = p
  #         other_player_list.game = @game
  #         other_player_list.save
  #         other_user_pair = Pair.new
  #         other_user_pair.user = @user
  #         other_user_pair.list = other_player_list
  #         pair.save
  #         those_two_users_pair = Pair.new
  #         those_two_users_pair.user = 
  #       end

  #     end

  #     # reset the user pair if the user has alrady paired all the other users
  #     if other_players.nil?
  #     end

  #   else
  #     render json: {
  #       pair: @pair_users
  #     }
  #   end
  # end

  def pair
    # the game creator will be able to access this function to broadcast to every whose their pair
    @game = Game.find(params[:id])
    @players = @games.users
    @round = params[:round]
  end

  private

  def game_params
    params.require(:game).permit(:round_number, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
