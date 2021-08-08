class ApplicationController < ActionController::API
  def encode_token(payload)
    secret_key_base = Rails.application.credentials.secret_key_base

    exp_payload = {
      data: payload,
      exp: Time.now.to_i + 2 * 3600,
    }

    JWT.encode(exp_payload, secret_key_base, 'HS256')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    secret_key_base = Rails.application.credentials.secret_key_base

    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, secret_key_base, true, algorithm: 'HS256')
      rescue JWT::DecodeError, JWT::ExpiredSignature => error
        render json: {
          errors: [error]
        }, status: :unauthorized and return
      end
    end
  end

  def contact
    @contact = params[:contact]

    ContactMailer.with(contact: @contact).auto_reply.deliver_later
  end
end
