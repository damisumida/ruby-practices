# frozen_string_literal: true

require 'minitest/autorun'

class Shot
  attr_reader :point

  def initialize(point)
    @point = point
  end

  def score
    return 10 if point == 'X'

    point.to_i
  end
end
