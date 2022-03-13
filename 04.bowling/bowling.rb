#!/usr/bin/env ruby
# frozen_string_literal: true

def add_strike_point(throw, inputs)
  return 0 if throw == 17

  point = add_point(throw + 1, inputs)
  point += add_point(throw + 2, inputs)
  point += 10
  point
end

def add_spare_point(throw, inputs)
  return 0 if throw == 17

  add_point(throw + 1, inputs)
end

def add_point(throw, inputs)
  return 10 if strike?(throw, inputs)

  inputs[throw].to_i
end

def strike?(throw, inputs)
  return true if inputs[throw] == 'X'

  false
end

score = 0
flame_point = 0
is_flame_end = false
inputs = ARGV[0].split(',')
throw_time = inputs.length

throw_time.times do |throw|
  if strike?(throw, inputs)
    score += add_strike_point(throw, inputs)
    flame_point = 0
    is_flame_end = false
    break if throw_time == throw + 3 # 10フェーズでストライクになったら終了

    next
  end

  score += add_point(throw, inputs)
  flame_point += add_point(throw, inputs)

  score += add_spare_point(throw, inputs) if flame_point == 10

  flame_point = 0 if is_flame_end
  is_flame_end = !is_flame_end
end

puts score
