require "minitest/autorun"
require "capybara/dsl"

require File.expand_path("app")

class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL
  
  def setup
    Capybara.app = Cuba
    # Capybara.javascript_driver = :webkit
  end

  def teardown
    Capybara.reset_sessions!
    # Capybara.use_default_driver
  end
end