# frozen_string_literal: true

class Api::V1::GamesController < Api::V1::BaseController
  def create
    token = params[:tokens][:token]
    openid = decode(token)['token']

    user = User.where(openid: openid)[0]
    @game = Game.new(game_params)
    # @game.find_partner_timer = game_params['find_partner_timer']
    # @game.selfie_timer = game_params['selfie_timer']
    # @game.question_timer = game_params['question_timer']
    # @game.round_number = game_params['round_number']
    @game.status = 'start'
    @game.user = user
    @game.save
    # get the access token to get the QR code
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
      url: url,
      room: @game.id
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

  def boardcast
    @game = Game.find(params[:id])

    ids = []
    @users = []
    u = @game.users
    # filter the people that is not in the room
    u.each do |user|
      puts user.id
      puts 'inside loop'
      unless ids.include?(user.id)
        ids << user.id
        @users << user
      end
    end
    ActionCable.server.broadcast("game_channel_#{params[:id]}",
                                 type: 'users',
                                 players: @users,
                                 round: @game.game_round_now)
  end

  def pair
    # create the hash that will be returned later
    pairs = {}

    # the game creator will be able to access this function to broadcast to every whose their pair
    @game = Game.find(params[:id])
    puts 'this line is running!!!!'

    @players = @game.users
    @round = params[:round].to_i
    @pairlist = @game.pairlists.first

    # find the current user
    token = params[:token]
    hash_openid = decode(token)
    openid = hash_openid['token']
    @user = User.find_by(openid: openid)

    return unless @game.user == @user

    r = @game.game_round_now + 1
    @game.update(game_round_now: r)

    @game.update(status: 'end') if r == @game.round_number
    # check whether the round is the less than the round number
    if r > @game.round_number
      ActionCable.server.broadcast("game_channel_#{params[:id]}",
                                   type: 'finish')
      return

    end

    # create the pairlist
    @players.each do |x|
      Pairlist.find_or_create_by(game: @game, user: x)
    end
    array_of_player_unique = []
    @players = @players.uniq

    # shuffle every user to match them
    @players = @players.shuffle

    # # allen's special version
    # if @round.to_i == 2
    #   @players.each do |p|
    #     p_token = { token: p.openid }
    #     p_authen = JWT.encode p_token, nil, 'none'
    #     pairs[p_authen] = ["placeholder for allen's phone", 'ask him everything']
    #   end
    #   render json: {
    #     pairs: pairs
    #   }
    #   return
    # end

    # check if the gamers have already played with all the other people
    check_list = @players.first.pairlists
    check_user = @game.users
    check_user.each do |h|
      check_user -= [h] if check_list.include?(h)
    end

    if check_user.length < 2
      # destroy all the pairs to start over
      puts "this is inside the destruction function \n\n\n\n\n\n\n\n\n\n\n"
      @game.pairlists.each do |r|
        r.gamerlists.each(&:destroy)
      end
    end

    if @players.length.odd?
      puts "inside the odd function\n\n\n\n\n\n"
      # get the last person to talk to allen
      puts "this is inside the odd function \n\n\n\n\n\n\n\n\n\n\n"
      @last_person = @players[-1]
      @players -= [@last_person]

      last_token = { token: @last_person.openid }
      last_authen = JWT.encode last_token, nil, 'none'

      # assign him to allen
      pairs[last_authen] = { user: 'talk to Allen', question: 'ask him everything' }
    end
    # use a for loop to find everyone's pair

    counter = 0
    puts @players.count
    second_counter = 0
    @players.each do |p|
      @players.each do |x|
        next if p.id == x.id

        counter += 1
        puts "\n\n\n\n\n\n\n\n\n\n\n\n inside the nested for loop #{x.inspect}#{p.inspect}"
        puts "this is inside the for loop!!!!!!! \n\n\n\n\n\n\n\n\n\n\n"
        # check whether the user has alrady paired with everyone else

        # check whether p has paired with x before
        @game = @game.reload
        @pairlists = @game.pairlists.reload
        @player1_pairlist = @pairlists.find { |y| y.user.id == p.id }
        break if @player1_pairlist.gamerlists.find { |x| x.game_round == @round.to_i }

        players_that_player1_that_has_already_played_with = @player1_pairlist.gamerlists.reload.collect { |gamerlist| gamerlist.user.id }
        second_counter += 1 if x.already_inside_another_users_gamerlist?(players_that_player1_that_has_already_played_with)
        next if x.already_inside_another_users_gamerlist?(players_that_player1_that_has_already_played_with)

        # check whether the use already has a pair this round

        # @player1_gamerlists = @player1_pairlist.gamerlists.reload
        # @player2_gamerlist = @player1_gamerlists.find { |z| z.user.id == x.id }
        # next if @player2_gamerlist.present?

        # this means the user the haven't paired with, so create a pair
        p_token = { token: p.openid }
        p_authen = JWT.encode p_token, nil, 'none'
        x_token = { token: x.openid }
        x_authen = JWT.encode x_token, nil, 'none'
        puts "in line 270\n\n\n\n"
        # add question to every two users
        t = Task.all.sample
        pairs[p_authen] = { user: x, question: t.description }
        pairs[x_authen] = { user: p, question: t.description }
        p pairs
        person1_gamerlist = Gamerlist.new
        person2_gamerlist = Gamerlist.new

        # get the pairlist for both p and x
        # find each user's existing pairlist for this game
        person1_pairlist = @game.pairlists.find { |a| a.user == p }
        person2_pairlist = @game.pairlists.find { |a| a.user == x }
        p person1_pairlist
        p person2_pairlist

        # for each pairlist & game list, update the users
        person1_pairlist.user = p
        person2_pairlist.user = x
        person1_gamerlist.user = p
        person2_gamerlist.user = x
        person1_gamerlist.game_round = @round
        person2_gamerlist.game_round = @round
        person1_pairlist.save
        person2_pairlist.save
        p person1_pairlist.errors
        p person2_pairlist.errors

        person1_gamerlist.pairlist = person2_pairlist
        person2_gamerlist.pairlist = person1_pairlist
        p person1_pairlist
        p person2_pairlist
        person1_gamerlist.save
        puts person1_gamerlist.errors.inspect
        person2_gamerlist.save
        puts person2_gamerlist.errors.inspect

        p '---------------'
        p "p's gamerlist: #{person1_gamerlist.id} - #{person1_gamerlist.user.id} - #{person1_gamerlist.pairlist.user.id}"
        p "x's gamerlist: #{person2_gamerlist.id} - #{person2_gamerlist.user.id} - #{person2_gamerlist.pairlist.user.id}"

        # # remove this two from the player list
        @players -= [p]
        @players -= [x]

        break
      end
    end
    puts counter
    puts second_counter
    p @players.collect(&:id)
    puts '&&&&&&&&&'
    puts @game.inspect
    puts 'But how many pairlists?'
    puts @game.pairlists.count
    puts 'But how about those gamelists for the users?'

    @game.users.each do |user|
      puts "Here's the pairlist in this game for user #{user.id} #{user.name}"
      pairlist = user.pairlists.find { |p| p.game == @game }
      pairlist.gamerlists.each do |gamerlist|
        puts "Here's the gamerlist #{gamerlist.id} for user with id #{gamerlist.user.name} matched to user #{user.name}"
      end

      puts "\n\n"
    end

    p pairs
    ActionCable.server.broadcast("game_channel_#{@game.id}",
                                 type: 'pair',
                                 pairs: pairs,
                                 round: @game.game_round_now)

    render json: {
      pairs: pairs
    }
  end

  private

  def game_params
    params.require(:game).permit(:round_number, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
