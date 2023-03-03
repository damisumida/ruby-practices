# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'

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