require 'gosu'

class Enemy
 attr_reader :x, :y, :attack, :health, :width, :height


   def initialize(window) # Add the window argument here
    @window = window # Store the window reference
    @x = 1200 # Adjust the initial position as needed
    @y = @window.height - 50
    @width = 50
    @height = 50
    @attack = 2
    @health = 100
  end

  def update(player)
    # Implement enemy movement logic if needed
    move_speed = 2 # Adjust the enemy's movement speed as needed

    if @x < player.x
      @x += move_speed
    elsif @x > player.x
      @x -= move_speed
    end

    # Check if enemy is at the same position as the player
    if @x == player.x
      player.take_damage(@attack)
    end


    # Check if enemy is at the same position as the player
    if @x == player.x
      player.take_damage(@attack)
    end
  end

  def take_damage(damage)
    @health -= damage
  end

  def die
    @window.instance_variable_get(:@enemies).delete(self)
  end

  def draw
    Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::RED)
  end
end
