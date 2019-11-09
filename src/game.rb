require 'rubygems'
require 'gosu'
require_relative './gameobject.rb'
require_relative './movable.rb'
require_relative './circle.rb'
require_relative './label.rb'
require_relative './tutorial.rb'

class Game
	def initialize(best_score)
		setup_menu
		@best_score = best_score
		@filter = Gosu::Color.argb(0x00_000000)
		@fading = :none
	end
	
	def reset
		setup
	end
	
	def setup
		@objects = Array.new
		@player = Movable.new(1920/2, 1080/2, 10, Gosu::Image.new("assets/ship_r.png"), Type::PLAYER, self)
		@circle = Circle.new
		@player.accelerate(7)
		@status = :playing
		@got_ammo = false
		@ammo = 0
		@score = 0
		@small = Gosu::Font.new(40)
		@big = Gosu::Font.new(75)
		@laser = Gosu::Sample.new("assets/laz0r.wav")
		@explosion = Gosu::Sample.new("assets/explosion.wav")
		@ammo_pickup = Gosu::Sample.new("assets/ammo.wav")
		@scored = false
	end
	
	def setup_menu
		@status = :main_menu
		@objects = Array.new
		@player = Movable.new(1920/2, 1080/2, 10, Gosu::Image.new("assets/ship_r.png"), Type::PLAYER, self)
		@circle = Circle.new
		@small = Gosu::Font.new(40)
		@big = Gosu::Font.new(75)
		addObject(Label.new(960 - (@big.text_width("PLAY")/2), 20, 20, @big, "PLAY"))
		addObject(Label.new(430 - (@big.text_width("INFO")/2), 503, 20, @big, "INFO"))
		addObject(Label.new(1490 - (@big.text_width("TUTORIAL")/2), 503, 20, @big, "TUTORIAL"))
		#addObject(Label.new(960 - (@big.text_width("SETTINGS")/2), 985, 20, @big, "SETTINGS"))
		@laser = Gosu::Sample.new("assets/laz0r.wav")
		@explosion = Gosu::Sample.new("assets/explosion.wav")
	end
	
	def setup_info
		@status = :info
		@info_image = Gosu::Image.new("assets/info.png")
	end
	
	def setup_tut
		@status = :tutorial
		@tutorial = Tutorial.new
	end
	
	def addObject(o)
		@objects.push(o)
	end
	
	def remove_object(o)
		@objects.delete(o)
	end
	
	def draw
		case @status
			when :playing
				@player.draw
				@objects.each { |o| o.draw }
				@circle.draw
				@big.draw("Ammo: #{ammo}", 10, 10, 20)
				@big.draw("Score: #{(score/100).to_s}", 1910 - @big.text_width("Score: #{(score/100).to_s}"), 10, 20)
			when :paused				
				@big.draw("Paused", (1920/2) - (@big.text_width("Paused")/2), (1080/2) - ((75 + 40 + 75) / 2), 20)
				@small.draw("Press SPACE to continue", (1920/2) - (@small.text_width("Press SPACE to continue")/2), (1080/2) + ((75 + 40 + 75) / 2), 20)
			when :main_menu
				@player.draw
				@objects.each { |o| o.draw }
				@small.draw("High score: #{@best_score/100}", 960 - @small.text_width("High score: #{@best_score/100}") / 2, 960, 20)
				@small.draw("Press SPACE to fire", 960 - @small.text_width("Press SPACE to fire") / 2, 1000, 20)
			when :gameover
				@big.draw("Game Over", (1920/2) - (@big.text_width("Game Over")/2), (1080/2) - ((75 + 75 + 40 + 75 + 40) / 2), 20)
				
				if !@scored
					@small.draw("Score:", (1920/2) - (@big.text_width("Game Over")/2), (1080/2) - ((75 + 75 + 40 + 75 + 40) / 2) + 75 + 75, 20)
					@small.draw((@score/100).to_s, (1920/2) + (@big.text_width("Game Over")/2) - @small.text_width((@score/100).to_s), (1080/2) - ((75 + 75 + 40 + 75 + 40) / 2) + 75 + 75, 20)
				else
					@small.draw("NEW HI SCORE!", (1920/2) - (@big.text_width("Game Over")/2), (1080/2) - ((75 + 75 + 40 + 75 + 40) / 2) + 75 + 75, 20, 1, 1, Gosu::Color::RED)
					@small.draw((@score/100).to_s, (1920/2) + (@big.text_width("Game Over")/2) - @small.text_width((@score/100).to_s), (1080/2) - ((75 + 75 + 40 + 75 + 40) / 2) + 75 + 75, 20, 1, 1, Gosu::Color::RED)
				end
				
				@small.draw("SPACE to restart, SHIFT to return to the main menu", (1920/2) - (@small.text_width("SPACE to restart, SHIFT to return to the main menu")/2), (1080/2) + ((75 + 75 + 40 + 75 + 40) / 2), 20)
			when :tutorial
				@tutorial.draw
			when :info
				@info_image.draw(0, 0, 100)
		end
		
		Gosu.draw_rect(0, 0, 1920, 1080, @filter, 500)
	end
	
	def update
		case @status
			when :playing
				add_score
				@objects.each do |o|
					#case decided to stop working for some reason
					if o.instance_of? Movable
						o.update
					elsif o.instance_of? GameObject
						if Gosu.distance(o.x, o.y, 1920/2, 1080/2) > (@circle.r - 100)
							remove_object(o)
						end
					end
				end
				@player.update
				@circle.update
			when :main_menu
				@player.update
				@objects.each do |o|
					o.update if o.instance_of? Movable
					if o.type == Type::BULLET
						@objects.each do |p|
							if p.type == Type::UI_LABEL
								if p.is_hit(o.x, o.y)
									@explosion.play
									case p.text
										when "PLAY"
											reset
										when "INFO"
											setup_info
										when "TUTORIAL"
											setup_tut
										#when "SETTINGS"
										#	setup_settings
									end
								end
							end
						end
					end
				end
			
		end
		
		case @fading
			when :in
				if @filter.alpha > 0x00
					@filter.alpha -= 5
				else
					@fading = :none
				end
			when :out
				if @filter.alpha < 0xff
					@filter.alpha += 5
				else
					@fading = :none
				end
		end
	end
		
	def gimme_ammo
		@got_ammo = true
		
		#TODO adjust if needed
		@ammo += 2
	end
	
	def enlarge_space
		@circle.r += 7
		@circle.x -= 7
		@circle.y -= 7
	end
	
	def space
		case @status
			when :playing
				return if ammo == 0
				@ammo -= 1
				@objects.push(Movable.new(@player.x, @player.y, 10, Gosu::Image.new("assets/bullet.png"), Type::BULLET, self, @player.direction, 50))
				@laser.play
			when :gameover
				reset
			when :paused
				@status = :playing
			when :main_menu
				@objects.push(Movable.new(@player.x, @player.y, 21, Gosu::Image.new("assets/bullet.png"), Type::BULLET, self, @player.direction, 50))
				@laser.play
			when :tutorial
				if @tutorial.i >= 2
					setup_menu
				else
					@tutorial.next_page
				end
			when :info
				setup_menu
		end
	end
	
	def over
		@status = :gameover
		if @score > @best_score
			@best_score = @score
			@scored = true
		end
				puts @best_score
	end
	
	def shift
		case @status
			when :playing
				@status = :paused
			when :gameover
				@status = :main_menu
				setup_menu
		end
	end
	
	def add_score(amount = 1)
		@score += amount
	end
	
	attr_reader :player, :objects, :status, :circle, :ammo, :score, :got_ammo, :laser, :explosion, :ammo_pickup, :best_score
	attr_writer :objects
end