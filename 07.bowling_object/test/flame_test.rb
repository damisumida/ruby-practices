require 'minitest/autorun'
require './flame.rb'

class FlameTest < Minitest::Test
  def test_strike
    flame1 = Flame.new('X', 0)
    refute flame1.spare?
    assert flame1.strike?
    assert_equal 10, flame1.score
  end

  def test_spare
    flame2 = Flame.new(3, 7)
    assert flame2.spare?
    refute flame2.strike?
    assert_equal 10, flame2.score
  end

  def test_nomal_score
    flame3 = Flame.new(4, 2)
    refute flame3.spare?
    refute flame3.strike?
    assert_equal 6, flame3.score
  end
end
