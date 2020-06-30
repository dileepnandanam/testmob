class Quaco

  API_FUNCTION_MAP = {
    'swipe_swipe' => 'w:' ,
    'swipe_swipe_and_return' => 'w:r:' ,
    'flick_flick' => 'f:l:' ,
    'touch_tap' => 't:f:' ,
    'move_to_xy_plane_move' => 'p:f:' ,
    'touch_event_move' => 't:e:' ,
    'touch_touch' => 't:f:' ,
    'touch_touch_and_return' => 't:r:' ,
    'touch_down_move' => 't:d:' ,
    'move_stm_up_move' => 't:u:' ,
    'torque_on' => 'm:f:' ,
    'torque_off' => 'm:0:' ,
    'get_pos' => 'f:' ,
    'home' => 'h:' ,
    'get_status' => 'm:q:' ,
    'move_interpolated_move' => 'p:' ,
    'touch_interpolated_tap' => 't:p:' ,
    'origin_set_origin' => 'o:s:' ,
    'origin_origin_reset' => 'o:r:' ,
    'ip_settings_set' => '' ,
    'base_led_on' => 'L:X:0' ,
    'base_led_off' => 'L:X:1' ,
    'power_restart' => '' ,
    'power_shutdown' => '' ,
    '5_volt_power_out_on' => '' ,
    '5_volt_power_out_off' => '' ,
    '2_volt_power_out_on' => '' ,
    '2_volt_power_out_off' => '' ,
    'rig_light_on' => '' ,
    'rig_light_off' => '' ,
    'buzzer_of' => 'b:0:' ,
    'dut_profile_name_set' => 'REDP:' 
  }


  @@connection = nil
  def self.connect(type)
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

  def self.disconnect
    self.connection.disconnect
  end

  def self.connection
    @@connection
  end

  def self.execute(user_id, line)
    self.connection.execute(user_id, line)
  end
end