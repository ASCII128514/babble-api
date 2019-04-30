# frozen_string_literal: true

class Api::V1::GamesController < Api::V1::BaseController
  def create
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
    @game.save
    render json: {
      game: @game
    }
  end

  private

  def game_params
    params.require(:game).permit(:round_number, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
