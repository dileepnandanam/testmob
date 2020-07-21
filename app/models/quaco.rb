class Quaco

  API_FUNCTION_MAP = {
    'swipe_swipe' => 'w:' ,
    'swipe_swipe_and_return' => 'w:r:' ,
    'flick_flick' => 'f:l:' ,
    'touch_tap' => 't:m:' ,
    'move_to_xy_plane_move' => 'p:f:' ,
    'touch_event_move' => 't:e:' ,
    'touch_touch' => 't:f:' ,
    'touch_touch_and_return' => 't:r:' ,
    'touch_down_move' => 't:d:' ,
    'move_stm_up_move' => 't:u:' ,
    'torque_on' => 'm:1:' ,
    'torque_off' => 'm:0:' ,
    'get_pos' => 'f:' ,
    'home' => 'h:' ,
    'get_status' => 'm:q:' ,
    'move_interpolated_move' => 'p:' ,
    'touch_interpolated_tap' => 't:p:' ,
    'origin_set_origin' => 'o:s:' ,
    'origin_origin_reset' => 'o:r:' ,
    'ip_settings_set' => 'IP:' ,
    'base_led_on' => 'L:0:' ,
    'base_led_off' => 'L:1:' ,
    'power_restart' => 's:0:' ,#platform
    'power_shutdown' => 's:1' ,#platform
    '5_volt_power_out_on' => 'DP:0:1:' ,#platform
    '5_volt_power_out_off' => 'DP:0:0:' ,#platform
    '12_volt_power_out_on' => 'DP:1:1:' ,#platform
    '12_volt_power_out_off' => 'DP:1:0:' ,#platform
    'rig_light_on' => 'XL:1:' ,
    'rig_light_off' => 'XL:0:' ,
    'buzzer_of' => 'b:0:' ,
    'dut_profile_name_set' => 'REDP:',
    'robot_lift_axis_z_axis_height' => 'ZP:',
    'robot_lift_axis_move' => 'ZH:'
  }


  @@connection = nil
  def self.connect(type)
    type = 'telnet'
    if type == 'tcp'
      @@connection = QuacoTcp
      QuacoTcp.connect
      QuacoTcp.connection.read
    else
      @@connection = QuacoTelnet
      QuacoTelnet.connect
      QuacoTelnet.connection.waitfor(/\n/)
    end
  end

  def self.flush
    @@connection && @@connection.connection.waitfor(/\n/)
  end

  def self.disconnect
    self.connection.disconnect
  end

  def self.connection
    @@connection
  end

  def self.closed?
    @@connection.nil? || @@connection.closed?
  end

  def self.execute(user_id, line)
    self.connection.execute(user_id, line)
  end
end