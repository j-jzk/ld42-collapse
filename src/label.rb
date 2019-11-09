require 'rubygems'
require 'gosu'
require_relative './gameobject.rb'

class Label < GameObject
	def initialize(x, y, z, font, text)
		super(x, y, z, nil, Type::UI_LABEL)
		@font = font
		@text = text
	end
	
	def draw
		@font.draw(@text, @x, @y, @z)
	end
	
	def is_hit(x, y)
		lefttop = [@x, @y]
		rightbot = [@x + @font.text_width(@text), @y + @font.height]
		return false if x < lefttop[0] or y < lefttop[1]
		return false if x > rightbot[0] or y > rightbot[1]
		return true
	end
	
	attr_reader :text
end