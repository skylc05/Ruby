require 'rubygems'
require 'gosu'
require './circle'

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(640, 400, false)
    self.caption = "House Drawing"

    @circle = Gosu::Image.new(Circle.new(40)) 
  end

  def draw
    draw_quad(0, 0, Gosu::Color::WHITE, 
              640, 0, Gosu::Color::WHITE, 
              0, 400, Gosu::Color::WHITE, 
              640, 400, Gosu::Color::WHITE, ZOrder::BACKGROUND)

    Gosu.draw_rect(220, 150, 200, 200, Gosu::Color::YELLOW, ZOrder::MIDDLE)

    draw_triangle(220, 150, Gosu::Color::RED, 
                  320, 50, Gosu::Color::RED, 
                  420, 150, Gosu::Color::RED, ZOrder::MIDDLE)

    @circle.draw(280, 180, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLUE)

    Gosu.draw_rect(290, 280, 60, 70, Gosu::Color::GREEN, ZOrder::MIDDLE)
  end
end

DemoWindow.new.show

