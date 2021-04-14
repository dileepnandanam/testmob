class InteractiveTestsController < ApplicationController
  before_action :check_user

  def index
    
  end

  def check
    render 'check', layout: false
  end

  def checker
    render 'checker', layout: false
  end

  protected

  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end