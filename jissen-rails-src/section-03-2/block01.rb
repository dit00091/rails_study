class Robot
  def job
    puts "Started."
    yield(self)
    puts "Finished."
  end
end

robot = Robot.new
robot.job { puts "Hello World!" }
