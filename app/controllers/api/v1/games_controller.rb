# frozen_string_literal: true

class Api::V1::GamesController < Api::V1::BaseController
  def create
    token = params[:tokens][:token]
    openid = decode(token)
    puts openid['token']
    puts "\n\n\n\n\n\n\n\n\n"
    user = User.where(openid: openid['token'])
    @game = Game.new(game_params)
    @game.user = user
    @game.save
    render json: {
      game: @game
    }
  end

  private

  def game_params
    params.require(:game).permit(:rounds, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
