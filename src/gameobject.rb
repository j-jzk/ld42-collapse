require 'rubygems'
require 'gosu'

class GameObject
	def initialize(x, y, z, image, type)
		@x = x
		@y = y
		@z = z
		@image = image
		@type = type
	end
	
	attr_accessor :x, :y, :z, :image, :type
	
	def draw
		image.draw(@x, @y, @z)
	end
	
end