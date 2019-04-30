# frozen_string_literal: true

class Api::V1::GamesController < Api::V1::BaseController
  def create
    token = params[:token]
    user = User.where(openid: decode(token)['token'])[0]
    Game.create(game_params)
  end

  private

  def game_params
    params.require(:game).permit(:rounds, :find_parter_timer, :selfie_timer, :question_timer)
  end
end
