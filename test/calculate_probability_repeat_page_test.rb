require 'test_helper'

class CalculateProbabilityRepeatPageTest < Minitest::Test
  def test_it_does_something_useful
    CalculateProbabilityRepeatPage.perform("#{Dir.pwd}/test/fixtures/test_data.csv")
    binding.pry
    assert false
  end
end
