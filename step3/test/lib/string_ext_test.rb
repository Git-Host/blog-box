require "minitest/autorun"

require File.expand_path("string_ext", "lib")

class StringExtTest < MiniTest::Unit::TestCase
  def test_blank?
    assert "".blank?
    assert " ".blank?
    assert "\n".blank?
    refute " zzz ".blank?
  end
  
  def test_present?
    refute "".present?
    refute " ".present?
    refute "\n".present?
    assert " zzz ".present?
  end
end