require 'rubygems'
require 'gosu'
require_relative './gameobject.rb'

class Tutorial < GameObject
	def initialize
		super(0, 0, 100, Gosu::Image.new("assets/tut0.png"), Type::TUTORIAL)
		@img_arr = []
		(0..2).each do |i|
			@img_arr[i] = Gosu::Image.new("assets/tut#{i}.png")
		end
		@i = 0
	end
	
	def next_page
		@i += 1
		image = @img_arr[@i]
	end
	
	def draw
		@img_arr[@i].draw(0, 0, 100)
	end
	
	attr_reader :i
end