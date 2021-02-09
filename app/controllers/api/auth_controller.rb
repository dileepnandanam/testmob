class Api::AuthController < ApplicationController
  def login
    email = params[:email]
    password = params[:password]

    user = User.find_by_email(email)
    if user && user.valid_password?(password)
      access_token = SecureRandom.uuid
      user.update(access_token: Digest::SHA1.hexdigest(access_token))
      render json: {
        email: email,
        access_token: access_token
      }
    else
      render json: {
        message: 'Wrong credentials'
      }
    end
  end
end