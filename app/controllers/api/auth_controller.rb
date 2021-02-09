class Api::AuthController < ApplicationController
  def login
    email = params[:email]
    password = params[:password]

    user = User.find_by_email(email)
    if user && user.valid_password?(password)
      user.update(access_token: SecureRandom.uuid)
      render json: {
        email: email,
        access_token: user.access_token
      }
    else
      render json: {
        message: 'Wrong credentials'
      }
    end
  end
end