#Encoding: UTF-8

require 'rubygems'
require 'gosu'
require './src/game'
require './src/gameobject'
require './src/movable'

module Type
	PLAYER, AMMO, SPACE_ENLARGER, ENEMY, BULLET, CIRCLE, UI_LABEL, TUTORIAL = *0..7
end

class ShrinkingSpace < Gosu::Window
	def initialize(game)
		super(1920, 1080)
		self.caption = "Collapse"
		@game = game
		@bgmusic = Gosu::Sample.new("assets/soundtrack.wav")
		@ch = @bgmusic.play
	end
	
	def update
		@ch = @bgmusic.play if !@ch.playing?
	
		@game.player.direction = Gosu.angle(@game.player.x, @game.player.y, mouse_x, mouse_y)
		@game.update
		if @game.status == :playing
			#@game.player.steer(-3) if Gosu.button_down? Gosu::KB_LEFT
			#@game.player.steer(3) if Gosu.button_down? Gosu::KB_RIGHT
			
			i = rand(100)
			if i <= 7 and @game.objects.size <= 25 * (530/@game.circle.r)
				x = rand(1920)
				y = rand(1080)
				while Gosu.distance(x, y, 1920/2, 1080/2) > (@game.circle.r - 100) or Gosu.distance(x, y, @game.player.x, @game.player.y) < 125 #so the items don't spawn outside the circle or too near to the player
					x = rand(1920)
					y = rand(1080)
				end
				case i
					when 0..2 #ammo
						@game.addObject(GameObject.new(x, y, 0, Gosu::Image.new("assets/ammo.png"), Type::AMMO))
					when 3..5 #space enlarger
						@game.addObject(GameObject.new(x, y, 0, Gosu::Image.new("assets/enlarge.png"), Type::SPACE_ENLARGER))
					when 6..7 #enemy
						if @game.got_ammo #so the enemies don't spawn to soon
							@game.addObject(Movable.new(x, y, 0, Gosu::Image.new("assets/enemy.png"), Type::ENEMY, @game, Gosu.angle(x, y, @game.player.x, @game.player.y), 6))
						end
				end
			end
		end
	end
	
	def draw
		@game.draw
	end
	
	#TODO custom cursor
	def needs_cursor?
		true
	end
	
	def button_down(id)
		case id
			when Gosu::KB_ESCAPE
				check_score
				close
			when Gosu::KB_LEFT_SHIFT
				@game.shift
			when Gosu::KB_SPACE
				@game.space
			else
				super
		end
	end
	
	def check_score
		File.open("config/bestscore", "w+") do |f|
			f.truncate(0)
			f.write(@game.best_score)
		end
	end
end

score = File.read("config/bestscore").to_i
ShrinkingSpace.new(Game.new(score)).show