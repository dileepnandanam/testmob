class UsersController < ApplicationController
  before_action :check_user
  def show
    @user = User.find(params[:id])
  end

  def request_demo
    current_user.update usertype: 'pending'
    UserMailer.with(user: current_user).inbound_demo_request.deliver_later
    redirect_to root_path
  end

  def accept_demo
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'client', start: nil, end: nil
    end
    redirect_to root_path
  end

  def pending_demo
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'pending', start: nil, end: nil
    end
    redirect_to root_path
  end

  def demo_finished
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'finished', start: nil, end: nil
    end
    redirect_to root_path
  end

  def update
    redirect_to root_path
  end

  protected

  def check_user
    unless current_user
      redirect_to new_user_session_path
    end
  end
end
