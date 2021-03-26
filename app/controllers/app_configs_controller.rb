class AppConfigsController < ApplicationController

  def connect
    Quaco.connect
    redirect_to configure_tests_path
  end

  def disconnect
    Quaco.disconnect
    redirect_to configure_tests_path
  end

  def connect_vision
    Vision.new.connect
    redirect_to configure_tests_path
  end

  def disconnect_vision
    Vision.new.disconnect
    redirect_to configure_tests_path
  end

  def flush
    Quaco.flush
    redirect_to new_test_path
  end

  def update
    unless current_user.usertype == 'platform'
      redirect_to root_path and return
    end

    config = AppConfig.find(params[:id])

    config.update params.require(:app_config).permit(:value)
    redirect_to configure_tests_path
  end
end