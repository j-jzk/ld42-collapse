require 'rubygems'
require 'gosu'
require_relative './gameobject.rb'
require_relative './game.rb'

class Movable < GameObject
	def initialize(x, y, z, image, type, game, direction=0, speed=0)
		super(x, y, z, image, type)
		@direction = direction
		@speed = speed
		@game = game
	end
	
	def steer(direction)
		@direction += direction
	end
	
	def accelerate(speed)
		@speed += speed
	end
	
	def update
		@vel_x = Gosu.offset_x(@direction, @speed)
		@vel_y = Gosu.offset_y(@direction, @speed)
		@x += @vel_x
		@y += @vel_y
		
		if @game.status == :playing
			if @type == Type::ENEMY
				#@direction = Gosu.angle(@x, @y, @game.player.x, @game.player.y)
				if Gosu.distance(@x, @y, 1920/2, 1080/2) > @game.circle.r
					@game.remove_object(self)
				end
				@game.objects.each do |o|
					if o.type == Type::BULLET
						if Gosu.distance(@x, @y, o.x, o.y) < 30
							@game.add_score(500)
							@game.explosion.play
							@game.remove_object(o)
							@game.remove_object(self)
						end
					end
				end
			elsif @type == Type::PLAYER
				if Gosu.distance(@x, @y, 1920/2, 1080/2) > @game.circle.r
					@game.over
				end
				@game.objects.each do |o|
					if Gosu.distance(@x + (image.width / 2), @y + (image.height / 2), o.x + (o.image.width / 2), o.y + (o.image.height / 2)) < 50
						case o.type
							when Type::AMMO
								@game.gimme_ammo
								@game.ammo_pickup.play
								@game.remove_object(o)
							when Type::SPACE_ENLARGER
								@game.enlarge_space
								@game.remove_object(o)
							when Type::ENEMY
								@game.over
								@game.remove_object(o)
						end
					end
				end
			else #bullet
				if Gosu.distance(@x, @y, 1920/2, 1080/2) > @game.circle.r
					@game.remove_object(self)
				end
			end
		end
	end
	
	def draw
		image.draw_rot(x, y, z, @direction)
	end
	
	attr_writer :game
	attr_accessor :direction, :speed
end
