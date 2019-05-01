# frozen_string_literal: true

class Api::V1::GamesController < WebsocketRails::BaseController
  def create
    puts "!!!!!!\n\n\n\n\n\n success \n\n\n\n\n\n\n"
    token = params[:tokens][:token]
    openid = decode(token)['token']
    puts openid
    puts "\n\n\n\n\n\n\n\n\n"
    user = User.where(openid: openid)[0]
    p game_params
    p user
    @game = Game.new(game_params)
    p @game
    # @game.find_partner_timer = game_params['find_partner_timer']
    # @game.selfie_timer = game_params['selfie_timer']
    # @game.question_timer = game_params['question_timer']
    # @game.round_number = game_params['round_number']
    p @game
    @game.user = user
    if @game.save
      send_message :create_success, game, namespace: :games
    else
      send_message :create_fail, game, namespace: :games
    end
  end

  def client_connected; end

  private

  def game_params
    params.require(:game).permit(:round_number, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
