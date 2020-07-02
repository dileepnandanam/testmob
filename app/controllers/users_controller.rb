class UsersController < ApplicationController
  before_action :check_user
  def show
    render plain: 'fghj'
  end

  def request_demo
    current_user.update usertype: 'pending'
    redirect_to root_path
  end

  def accept_demo
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'client'
    end
    redirect_to root_path
  end

  def pending_demo
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'pending'
    end
    redirect_to root_path
  end

  protected

  def check_user
    unless current_user
      redirect_to new_user_sessions_path
    end
  end
end
