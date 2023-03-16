# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'

class Flame
  MAX_POINT = 10
  attr_reader :second_point, :first_point, :third_point

  def initialize(first_point, second_point, third_point = nil)
    @first_point = Shot.new(first_point)
    @second_point = Shot.new(second_point)
    @third_point = Shot.new(third_point)
  end

  def spare?
    return false if strike?

    first_point.score + second_point.score == MAX_POINT
  end

  def strike?
    first_point.score == MAX_POINT
  end

  def score
    [first_point.score, second_point.score, third_point.score].sum
  end
end
