class QuacoInstructionBuilder
  def initialize(action, params)
    @action = action
    @params = params
  end

  def build
    if(@params.keys.include?('x'))
      x,y = Vision.new.get_coordinates(@params[:x], @params[:y])
      @params.merge({x:x, y:y})
    end
    if(@params.keys.include?('x1'))
      x1,y1 = Vision.new.get_coordinates(@params[:x1], @params[:y1])
      @params.merge({x1:x1, y1:y1})
    end
    if(@params.keys.include?('x2'))
      x2,y2 = Vision.new.get_coordinates(@params[:x2], @params[:y2])
      @params.merge({x2:x2, y2:y2})
    end
    command = INSTRUCTION_MAP[@action].call(@params)
    return command
  end

  SPEED = 150
  BACK_POS = 24
  FORCE = 100
  DURATION = 20
  DELAY = 2
  DIRECTION = 1
  TAPS = 5

  INSTRUCTION_MAP = {
    'swipe_swipe' => -> (p) {"w:#{p[:x1]}:#{p[:y1]}:#{p[:x2]}:#{p[:y2]}:#{SPEED}:"},
    'swipe_swipe_and_return' => -> (p) {"w:#{p[:x1]}:#{p[:y1]}:#{p[:x2]}:#{p[:y2]}:#{SPEED}:"},
    'flick_flick' => -> (p) {"w:#{p[:x1]}:#{p[:y1]}:#{p[:x2]}:#{p[:y2]}:#{SPEED}:"},
    'touch_tap' => -> (p) {"t:m:#{p[:x]}:#{p[:y]}:#{TAPS}:#{DELAY}:#{BACK_POS}:#{FORCE}:"},
    'move_to_xy_plane_move' => -> (p) {"p:f:#{p[:x]}:#{p[:y]}:"},
    'touch_event_move' => -> (p) {"t:e:#{DURATION}:#{BACK_POS}:#{FORCE}:"},
    'touch_touch' => -> (p) {"t:f:#{p[:x]}:#{p[:y]}:#{DURATION}:#{BACK_POS}:#{FORCE}:"},
    'touch_touch_and_return' => -> (p) {"t:r:#{p[:x]}:#{p[:y]}:#{DURATION}:#{BACK_POS}:#{FORCE}:"},
    'touch_down_move' => -> (p) {"t:d:#{FORCE}:"},
    'move_stm_up_move' => -> (p) {"t:u:#{BACK_POS}:"},
    'torque_on' => -> (p) {"m:1:"},
    'torque_off' => -> (p) {"m:0:"},
    'get_pos' => -> (p) {"f:"},
    'home' => -> (p) {"h:"},
    'get_status' => -> (p) {"m:q:"},
    'move_interpolated_move' => -> (p) {"p:#{p[:x]}:#{p[:y]}:#{SPEED}:"},
    'touch_interpolated_tap' => -> (p) {"t:p:#{p[:x]}:#{p[:y]}:#{SPEED}:#{DURATION}:#{BACK_POS}:#{FORCE}:"},
    'origin_set_origin' => -> (p) {"o:s:#{p[:x]}:#{p[:y]}:"},
    'origin_origin_reset' => -> (p) {"o:r:#{p[:x]}:#{p[:y]}:"},
    'ip_settings_set' => -> (p) {"IP:"},
    'base_led_on' => -> (p) {"L:0:"},
    'base_led_off' => -> (p) {"L:1:"},
    'power_restart' => -> (p) {"s:0:"},#platform
    'power_shutdown' => -> (p) {"s:1:"},#platform
    '5_volt_power_out_on' => -> (p) {"DP:0:1:"},#platform
    '5_volt_power_out_off' => -> (p) {"DP:0:0:"},#platform
    '12_volt_power_out_on' => -> (p) {"DP:1:1:"},#platform
    '12_volt_power_out_off' => -> (p) {"DP:1:0:"},#platform
    'rig_light_on' => -> (p) {"XL:1:"},
    'rig_light_off' => -> (p) {"XL:0:"},
    'buzzer_of' => -> (p) {"b:0:"},
    'dut_profile_name_set' => -> (p) {"REDP:"},
    'robot_lift_axis_z_axis_height' => -> (p) {"ZP:#{p[:height]}:"},
    'robot_lift_axis_move' => -> (p) {"ZH:#{p[:height]}:"},
    'dimenzio_move_to_xy_plane_move' => -> (p) {"p:"},
    'dimenzio_pick_card' => -> (p) {"m:"},
    'dimenzio_drop_card' => -> (p) {"n:"},
    'dimenzio_press_button' => -> (p) {"b:"}
  }
end