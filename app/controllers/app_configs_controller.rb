class AppConfigsController < ApplicationController

  def connect
    Quaco.connect(params[:type])
    redirect_to configure_tests_path
  end

  def disconnect
    Quaco.disconnect
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
    AppConfig.find(params[:id]).update params.require(:app_config).permit(:value)
    redirect_to configure_tests_path
  end
end