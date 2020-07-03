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
    @user = User.find(params[:id])
    render 'schedule', layout: false
  end

  def pending_demo
    if current_user.usertype == 'platform'
      User.find(params[:id]).update usertype: 'pending', start: nil, end: nil
    end
    redirect_to root_path
  end

  def update
    user_params = params.require(:user).permit(:start, :end)
    binding.pry
    User.find(params[:id]).update user_params.merge(usertype: 'client')
    redirect_to root_path
  end

  protected

  def check_user
    unless current_user
      redirect_to new_user_sessions_path
    end
  end
end
