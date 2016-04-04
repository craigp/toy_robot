class Robot

  attr_reader :position

  def initialize
    @position = { x: 0, y: 0 }
    @orientations = [:north, :east, :south, :west]
    @placed = false
    @upperbound, @lowerbound = 4, 0
  end

  def orientation
    @orientations[0]
  end

  def placed?
    @placed
  end

  def place(x, y, orientation)
    @position = check_position({ x: x, y: y })
    @placed = true
    left until @orientations[0] == orientation
  end

  def move
    if placed?
      position = @position.dup
      case @orientations[0]
      when :north
        position[:y] = position[:y] + 1
      when :south
        position[:y] = position[:y] - 1
      when :east
        position[:x] = position[:x] + 1
      when :west
        position[:x] = position[:x] - 1
      end
      @position = check_position(position)
    end
  end

  def check_position(position)
    [:x, :y].each { |k| position[k] = [[@lowerbound, position[k]].max, @upperbound].min }
    position
  end

  def left
    @orientations.unshift(@orientations.pop) if placed?
  end

  def right
    @orientations.push(@orientations.shift) if placed?
  end

  def report
    puts '%s,%s,%s' % [@position[:x], @position[:y], @orientations[0].to_s.upcase] if placed?
  end

  def parse(command)
    case command
    when /PLACE (\d{1}),(\d{1}),(NORTH|SOUTH|EAST|WEST)/
      place(Integer($1), Integer($2), $3.downcase.intern)
    when /MOVE/
      move
    when /LEFT/
      left
    when /RIGHT/
      right
    when /REPORT/
      report
    end
  end

end

if $0 == __FILE__
  if $*.length > 0
    path = File.join(__dir__, $*[0])
    if File.exists?(path)
      robot = Robot.new
      File.open(path, 'r') do |file|
        while command = file.gets
          robot.parse(command.strip)
        end
      end
    else
      puts "File not found: %s" % path
    end
  else
    robot = Robot.new
    while command = $stdin.gets
      break if command.strip.empty?
      robot.parse(command)
    end
  end
end
