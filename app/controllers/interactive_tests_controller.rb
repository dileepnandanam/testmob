class InteractiveTestsController < ApplicationController
  before_action :check_user

  def index
    
  end

  protected

  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end