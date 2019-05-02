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
    @game.user = user
    @game.save
    # get the access token to get the QR code
    res = JSON.parse(RestClient.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{ENV['APPID']}&secret=#{ENV['SECRET_KEY']}"))
    # return the QR code to the user
    access_token = res['access_token']

    img = RestClient.post("https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token#{access_token}", { "scene": "room=#{@game.id}" }.to_json).body
    puts "\n\n\n\n\n\n\n\n\n"
    p img
    File.open('QRcode.png', 'wb') do |file|
      file << img
    end

    ob = `curl -X POST \
  -H "X-LC-Id: qaxMtbr0N9ldQALQk8k7M14Q-gzGzoHsz" \
  -H "X-LC-Key: SorVkQ5HF4Ic9HfN8ajsNa9l" \
  -H "Content-Type: image/png" \
  --data-binary "@test.png"  \
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

  private

  def game_params
    params.require(:game).permit(:round_number, :find_partner_timer, :selfie_timer, :question_timer)
  end
end
