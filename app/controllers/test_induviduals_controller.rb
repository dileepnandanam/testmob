class TestInduvidualsController < ApplicationController
  before_action :check_user
  def advanced_mode
    render 'test_induvidual_common_template', layout: false
  end

  def basic_motion
    render 'test_induvidual_common_template', layout: false
  end

  def connections
    render 'test_induvidual_common_template', layout: false
  end

  def developer
    render 'test_induvidual_common_template', layout: false
  end

  def interpolated_mode
    render 'test_induvidual_common_template', layout: false
  end

  def others
    render 'test_induvidual_common_template', layout: false
  end

  def power_control
    render 'test_induvidual_common_template', layout: false
  end

  def rig_control
    render 'test_induvidual_common_template', layout: false
  end

  protected

  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end
