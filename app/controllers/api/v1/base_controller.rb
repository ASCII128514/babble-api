# frozen_string_literal: true

class Api::V1::BaseController < ActionController::API
  rescue_from StandardError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def internal_server_error(exception)
    response = if Rails.env.development?
                 { type: exception.class.to_s, error: exception.message }
               else
                 { error: 'Internal Server Error' }
    end
    render json: response, status: :internal_server_error
  end

  def decode(token)
    # decode the jwt token to the open id
    t = JWT.decode token, nil, false
    t[0]
  end

  def token_params
    params.require(:tokens).permit(:token)
  end
end
