# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'flame'

FLAME_SIZE = 10

class Game
  attr_reader :pinfall_text

  def initialize(pinfall_text)
    @flames = create_flames(pinfall_text)
  end

  def create_flames(pinfall_text)
    pinfall_text = pinfall_text.split(',')
    flames = []
    index = 0
    FLAME_SIZE.times do |i|
      if FLAME_SIZE == i + 1
        flames << Flame.new(pinfall_text[index], pinfall_text[index + 1], pinfall_text[index + 2])
      elsif pinfall_text[index] == 'X'
        flames << Flame.new(pinfall_text[index], nil)
        index += 1
      else
        flames << Flame.new(pinfall_text[index], pinfall_text[index + 1])
        index += 2
      end
    end
    flames
  end

  def calc_score
    score = 0
    @flames.each_with_index do |flame, index|
      score += flame.score
      score += strike_bonus_score(index) if flame.strike? && FLAME_SIZE != index + 1
      score += spare_bonus_score(index) if flame.spare? && FLAME_SIZE != index + 1
    end
    score
  end

  def strike_bonus_score(index)
    if @flames[index + 1].strike? && FLAME_SIZE != index + 2
      @flames[index + 1].first_point.score + @flames[index + 2].first_point.score
    else
      @flames[index + 1].first_point.score + @flames[index + 1].second_point.score
    end
  end

  def spare_bonus_score(index)
    @flames[index + 1].first_point.score
  end
end
