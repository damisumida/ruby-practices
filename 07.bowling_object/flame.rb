# frozen_string_literal: true

require 'minitest/autorun'
require_relative './shot.rb'

class Flame
  attr_reader :second_point, :first_point, :third_point

  def initialize(first_point, second_point, third_point = nil)
    @first_point = Shot.new(first_point)
    @second_point = Shot.new(second_point)
    @third_point = Shot.new(third_point)
  end

  def spare?
    return false if first_point.score == 10
    return true if first_point.score + second_point.score == 10

    false
  end

  def strike?
    first_point.score == 10
  end

  def score
    [first_point.score, second_point.score, third_point.score].sum
  end
end

class FlameTest < Minitest::Test
  def test_flame
    flame1 = Flame.new('X', 0)
    refute flame1.spare?
    assert flame1.strike?
    assert_equal 10, flame1.score

    flame2 = Flame.new(3, 7)
    assert flame2.spare?
    refute flame2.strike?
    assert_equal 10, flame2.score

    flame3 = Flame.new(4, 2)
    refute flame3.spare?
    refute flame3.strike?
    assert_equal 6, flame3.score
  end
end
