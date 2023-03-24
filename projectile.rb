require 'gosu'

class Projectile
  attr_reader :x, :y, :width, :height

  def initialize(window, x, y, direction_x, direction_y)
    @window = window
    @x = x
    @y = y
    @width = 10
    @height = 10
    @direction_x = direction_x
    @direction_y = direction_y
    @speed = 10
  end

  def update
    @x += @speed * @direction_x
    @y += @speed * @direction_y
  end

  def draw
    Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::BLUE)
  end
end


