require "minitest/autorun"

require File.expand_path("nil_class_ext", "lib")

class NilClassExtTest < MiniTest::Unit::TestCase
  def test_nil_is_blank?
    assert nil.blank?
  end
  
  def test_nil_is_not_present?
    refute nil.present?
  end
end