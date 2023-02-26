# frozen_string_literal: true

require 'minitest/autorun'
require './flame.rb'

FLAME_SIZE = 10

class Game
  attr_reader :pinfall_text

  def initialize(pinfall_text)
    @flames = create_flames(pinfall_text)
  end

  def create_flames(pinfall_text)
    pinfall_text = add_strike_second_pinfall(pinfall_text)
    punctuate_pinfall_text(pinfall_text)
  end

  def add_strike_second_pinfall(pinfall_text)
    pinfall_text = pinfall_text.split(',')
    new_pinfall_text = []
    pinfall_text.each_with_index do |point, index|
      new_pinfall_text << point
      new_pinfall_text << nil if point == 'X' && pinfall_text.size - 3 > index
    end
    new_pinfall_text
  end

  def punctuate_pinfall_text(pinfall_text)
    flames = []
    FLAME_SIZE.times do |i|
      if FLAME_SIZE == i + 1
        flames << Flame.new(pinfall_text[i * 2], pinfall_text[i * 2 + 1], pinfall_text[i * 2 + 2])
      else
        flames << Flame.new(pinfall_text[i * 2], pinfall_text[i * 2 + 1])
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

class GameTest < Minitest::Test
  def test_game
    game1 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game1.calc_score

    game2 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game2.calc_score

    game3 = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game3.calc_score

    game4 = Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, game4.calc_score

    game5 = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game5.calc_score
  end
end
