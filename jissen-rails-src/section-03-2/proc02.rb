class Robot
  attr_reader :x, :y
  attr_handler :handler
  def initialize
    @x = 0
    @y = 0
    @handler = -> { move(1, 0) }
  end

  def walk
    @handler.call
    puts "(x, y) = (#{@x}, #{@y})"
  end

  def move(d1, d2)
    @x += d1
    @y += d2
  end
end

r = Robot.new
r.walk
r.walk
r.handler = -> { r.move(0, 1) }
r.walk
r.handler = -> { r.x <= 2 ? r.move(1, 1) : r.move(-1, 1) }
r.walk
r.walk
