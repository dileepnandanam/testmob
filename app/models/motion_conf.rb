class MotionConf
  def self.update
    conf = ApplicationController.render(
      template: 'motion_conf/nginx',
      layout: false,
      assigns: {current_user: nil}
    )
    conf_file = File.open(Rails.root.join('nginx_motion'), 'w')
    conf_file.write(conf)
    conf_file.close
  end
end