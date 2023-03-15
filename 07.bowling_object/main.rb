# frozen_string_literal: true

require_relative 'game'

argv = ARGV[0]
game = Game.new(argv)
puts game.calc_score
