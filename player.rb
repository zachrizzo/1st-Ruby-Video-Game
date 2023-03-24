require 'gosu'

class Player
  attr_reader :x, :y, :attack, :health, :width, :height

  def initialize(window)
    @window = window
    @x = 0
    @y = 0
    @speed = 5
    @gravity = 1
    @velocity_y = 0
    @jump_speed = 15
    @jumping = false
    @attack = 3
    @health = 100
    @width = 50
    @height = 50

  end

  def update
    # Apply gravity
    @velocity_y += @gravity

    # Check for jump input
    if @window.button_down?(Gosu::KbSpace) && !@jumping
      @jumping = true
      @velocity_y = -@jump_speed
    end

    # Move left
    if @window.button_down?(Gosu::KbLeft)
      @x -= @speed
    end

    # Move right
    if @window.button_down?(Gosu::KbRight)
      @x += @speed
    end

    # Update player's vertical position
    @y += @velocity_y

    # Check for collision with ground
    if @y + 50 > @window.height
      @y = @window.height - 50
      @jumping = false
      @velocity_y = 0
    end
  end

  def take_damage(amount)
    @health -= amount
    @health = 0 if @health < 0
  end

  def hit(enemy)
    bounce_distance = 50
    if @x < enemy.x
        @x -= bounce_distance
      elsif @x > enemy.x
        @x += bounce_distance
      end
    if !@jumping
      @jumping = true
      @velocity_y = -5
    end
    # Update player's vertical position
    @y += @velocity_y

  end

  def draw
    Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::WHITE)
  end
end
