class MotionConf
  def self.update
    conf = ApplicationController.render(
      template: 'motion_conf/nginx',
      layout: false,
      assigns: {current_user: nil}
    )
    conf_file = File.open(Rails.root.join('shared/nginx_motion'), 'w')
    conf_file.write(conf)
    conf_file.close
    `sudo /usr/sbin/service nginx restart`
  end
end