require "minitest/autorun"

require File.expand_path("string_ext", "lib")

class StringExtTest < MiniTest::Unit::TestCase
  def test_for_blank_strings
    assert "".blank?
    assert " ".blank?
    assert "\n".blank?
    refute " zzz ".blank?
  end
  
  def test_for_non_blank_strings
    refute "".present?
    refute " ".present?
    refute "\n".present?
    assert " zzz ".present?
  end
end