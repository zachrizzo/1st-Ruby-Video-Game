require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'projectile'


class GameWindow < Gosu::Window
  def initialize
    super(1580, 560, false)
    self.caption = "My Game"
    @player = Player.new(self)
    @enemies = [] # Initialize the enemies array as empty
    @spawn_timer = 0 # Initialize a spawn timer
    @font = Gosu::Font.new(self, Gosu.default_font_name, 20) # Load the font
    @projectiles = [] # Initialize the projectiles array as empty
    @enemies_killed = 0 # Initialize the enemies killed counter
  end

  def update
    @player.update
    @enemies.reject! { |enemy| enemy.nil? } # Remove nil enemies from the array
    update_enemies
    @projectiles.each(&:update) # Update each projectile
    update_spawn_timer
    spawn_enemies(1) # Spawn 5 enemies every 5 seconds
    check_projectile_collisions() # Check for projectile collisions
  end


  def draw
    @player.draw if @player.health > 0
    draw_game_over() if @player.health <= 0
    # Draw the enemies if health is greater than 0
    @enemies.each { |enemy| enemy.draw if enemy.health > 0 }
    draw_player_health()
    @projectiles.each(&:draw) # Draw each projectile
end

  def button_down(id)
    super
    close if id == Gosu::KbEscape
    shoot_projectile if id == Gosu::MsLeft # Add this line to handle left mouse button clicks
  end

  def needs_cursor?
    true
  end

  def update_spawn_timer
    @spawn_timer += 1
  end

  def spawn_enemies(num_enemies)
  if @spawn_timer >= 5 * 6 # 5 seconds, assuming 60 updates per second
    enemies_to_spawn = num_enemies - @enemies_killed
    enemies_to_spawn.times do
      @enemies << Enemy.new(self)
    end
    @spawn_timer = 0 # Reset the timer
  end
end


  def update_enemies
  @enemies.each do |enemy|
    enemy.update(@player)

    if enemy && colliding?(@player, enemy) # Ensure enemy exists before checking collisions
      @player.take_damage(enemy.attack()) # Adjust the damage amount as needed
      @player.hit(enemy)
    end

    check_projectile_collisions if enemy # Ensure enemy exists before checking projectile collisions

    if enemy.health <= 0
      enemy.die
      @enemies.delete(enemy)
      @enemies_killed += 1

    end
  end
end



  def update_player_position(mouse_x, mouse_y)
    @player.x = mouse_x
    @player.y = mouse_y
  end

  def check_projectile_collisions
  @projectiles.each do |projectile|
    @enemies.each do |enemy|
      if colliding?(projectile, enemy)
        enemy.take_damage(60) # Adjust the damage amount as needed
        @projectiles.delete(projectile)
        puts "Enemy health: #{enemy.health}"
        break # Exit the inner loop if a collision was detected
      end
    end
  end
end


  def colliding?(obj1, obj2)
    obj1.x < obj2.x + obj2.width &&
      obj1.x + obj1.width > obj2.x &&
      obj1.y < obj2.y + obj2.height &&
      obj1.y + obj1.height > obj2.y
  end

  def shoot_projectile
    mouse_x, mouse_y = mouse_x(), mouse_y() # Get the mouse coordinates
    direction_x, direction_y = normalize_vector(mouse_x - @player.x, mouse_y - @player.y)
    @projectiles << Projectile.new(self, @player.x + @player.width, @player.y + @player.height / 2, direction_x, direction_y)
  end

  def normalize_vector(x, y)
    length = Math.sqrt(x * x + y * y)
    [x / length, y / length]
  end

  def draw_player_health
    health_text = "Health: #{@player.health}"
    @font.draw_text(health_text, 10, 10, 10, 1.0, 1.0, Gosu::Color::WHITE) # Set the z value to 10
  end
  def draw_game_over
    end_text= "Game Over"
    kill_text= "You killed #{@enemies_killed} enemies"
    #draw in the middle of the screen\
    @font.draw_text(end_text, 1580/2, 560/2, 10, 1.0, 1.0, Gosu::Color::WHITE) # Set the z value to 10
    @font.draw_text(kill_text, 1580/2-10, 560/2+30, 10, 1.0, 1.0, Gosu::Color::WHITE) # Set the z value to 10


  end

end

window = GameWindow.new
window.show
