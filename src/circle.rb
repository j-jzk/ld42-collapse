require 'rubygems'
require 'gosu'
require_relative './gameobject.rb'

class Circle < GameObject
	def initialize(x = 430, y = 10, z = -1)
		super(x, y, z, Gosu::Image.new("assets/circle.png"), Type::CIRCLE)
		@r = 530
	end
	
	def draw
		image.draw(x, y, z, @r/530.0, @r/530.0)
	end
	
	def update
		@r -= 0.2
		@x += 0.2
		@y += 0.2
	end
	
	attr_accessor :r
end