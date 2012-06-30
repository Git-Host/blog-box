require "minitest/autorun"
require "tempfile"

require File.expand_path("settings", "lib")

class SettingsTest < MiniTest::Unit::TestCase
  def setup
    @settings_file = Tempfile.new("blog-box")
    @settings = Settings.new(@settings_file.path)
  end
  
  def test_writes_setttings
    assert_equal "mykey", @settings["key"] = "mykey"
    assert_equal "mysecret", @settings["secret"] = "mysecret"
  end
  
  def test_reads_settings
    @settings["key"] = "mykey"
    assert_equal "mykey", @settings["key"]
  end
  
  def teardown
    @settings_file.close
    @settings_file.unlink
  end
end