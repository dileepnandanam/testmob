module ApplicationHelper
  PHASE_MAP = {
    'tests_index' => 'builds',
    'tests_new'  => 'new_build',
    'home_show' => 'users',
    'tests_configure' => 'config',
    'test_induviduals_advanced_mode' => 'test',
    'test_induviduals_basic_motion' => 'test',
    'test_induviduals_connections' => 'test',
    'test_induviduals_developer' => 'test',
    'test_induviduals_interpolated_mode' => 'test',
    'test_induviduals_others' => 'test',
    'test_induviduals_power_control' => 'test',
    'test_induviduals_rig_control' => 'test',
    'interactive_tests_index' => 'interactive_tests',
    'meter_tests_index' => 'meter_tests'
  }

  def phase(name)
    PHASE_MAP["#{controller_name}_#{action_name}"] == name
  end
end
