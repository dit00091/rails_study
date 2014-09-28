class Robot
  attr_writer :name

  def name
    @name ||= "ROBOT"
  end
end
