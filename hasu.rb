#!/usr/bin/env ruby
require 'hasu'
require 'pry'

Hasu.load 'ball.rb'
Hasu.load 'circle.rb'

class Game < Hasu::Window
  attr_accessor :current_frame_time

  def initialize
    @width = 800
    @height = 680

    super(@width, @height, false)
    self.caption = 'Regen'
    reset
  end

  def reset
    @balls = []
    (50..@width-50).step(15) do |w|
      (50..@height-50).step(15) do |h|
        @balls << Ball.new(w, h, 11)
      end
    end
    @img = Gosu::Image.new(self, Circle.new(50), false)
    @xpos = @ypos = 0
    @speed = 1
  end

  def update
    @current_frame_time = Gosu::milliseconds
    @xpos = mouse_x-50
    @ypos = mouse_y-50

    if rand > 0.985
      @balls.each_with_index do |ball, i|
        ball.blink!(duration_ms: 600, offset_ms: 50*i)
      end
    end
    handle_keyboard
  end

  def draw
    @balls.each {|ball| ball.draw(self) }
    @img.draw @xpos,@ypos,0
  end

  def button_down(btn_id)
    case btn_id
    when Gosu::MsLeft
      @balls.last.blink!(duration_ms: 2000)
    when Gosu::KbF
      @balls.each_with_index do |ball, i|
        ball.blink!(duration_ms: 500, offset_ms: 50*i)
      end
    when Gosu::KbR
      reset
    when Gosu::KbQ
      exit if button_down?(Gosu::KbRightShift) || button_down?(Gosu::KbLeftShift)
    end
  end

  def handle_keyboard
    if button_down?(Gosu::KbUp)
      @ypos -= 1*@speed
    end
    if button_down?(Gosu::KbDown)
      @ypos += 1*@speed
    end
    if button_down?(Gosu::KbRight)
      @xpos += 1*@speed
    end
    if button_down?(Gosu::KbLeft)
      @xpos -= 1*@speed
    end
    if button_down?(Gosu::KbA)
      @speed += 0.1
    end
    if button_down?(Gosu::KbZ)
      @speed -= 0.1
    end
  end
end


Game.run
