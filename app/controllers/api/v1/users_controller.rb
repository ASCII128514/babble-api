# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def login
    code = params[:code]
    puts code.nil?
    if code.nil?
      # retreive the user info if they already have one format: { token: 'token' }
      a = token_params
      authen = a['token']
      # retrieve the openid from the authen
      openid = decode(authen)
      @user = User.find_or_create_by(openid: openid['token'])
      @game = @user.games
      render json: {
        status: 200,
        game: @game,
        currentUser: @user
      }
    else
      # send info to the wehat api to get open id and store them into the storage
      token = RestClient.get("https://api.weixin.qq.com/sns/jscode2session?appid=#{ENV['APPID']}&secret=#{ENV['SECRET_KEY']}&js_code=#{params[:code]}&grant_type=authorization_code")
      # parse into json format and store the openid in the hash
      openid = JSON.parse(token)['openid']
      payload = { token: openid }

      # store all the info from the user
      @user = User.find_or_create_by(openid: openid)

      authen = JWT.encode payload, nil, 'none'
      render json: {
        authen: authen,
        currentUser: @user
      }
    end
  end

  def profile
    # find the current user
    token = params[:token]
    hash_openid = decode(token)
    openid = hash_openid['token']
    @user = User.find_by(openid: openid)
    @user.update(selfie: params[:url])
  end

  def name
    # find the current user
    token = params[:token]
    hash_openid = decode(token)
    openid = hash_openid['token']
    @user = User.find_by(openid: openid)
    @user.update(name: params[:name])
  end
end
