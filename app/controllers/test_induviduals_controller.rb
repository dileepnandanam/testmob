class TestInduvidualsController < ApplicationController
  before_action :check_user
  def advanced_mode
    render 'test_induvidual_common_template'
  end

  def basic_motion
    render 'test_induvidual_common_template'
  end

  def connections
    render 'test_induvidual_common_template'
  end

  def developer
    render 'test_induvidual_common_template'
  end

  def interpolated_mode
    render 'test_induvidual_common_template'
  end

  def others
    render 'test_induvidual_common_template'
  end

  def power_control
    render 'test_induvidual_common_template'
  end

  def rig_control
    render 'test_induvidual_common_template'
  end

  protected

  def check_user
    unless ['platform', 'client'].include? current_user.try(:usertype)
      redirect_to root_path
    end
  end
end
