class Robot2

  attr_reader :position, :orientation

  NORTH = 1
  EAST = 2
  SOUTH = 4
  WEST = 8

  def initialize
    @position = { x: 0, y: 0 }
    @orientation = NORTH
    @placed = false
    @upperbound, @lowerbound = 4, 0
  end

  def place(x, y, orientation)
    @position = check_position({ x: x, y: y })
    @placed = true
    left until @orientation == Object.const_get('Robot2::%s' % orientation)
  end

  def orientation
    return 'NORTH' if @orientation & Robot2::NORTH == Robot2::NORTH
    return 'SOUTH' if @orientation & Robot2::SOUTH == Robot2::SOUTH
    return 'EAST' if @orientation & Robot2::EAST == Robot2::EAST
    return 'WEST' if @orientation & Robot2::WEST == Robot2::WEST
  end

  def placed?
    @placed
  end

  def move
    if @placed
      position = @position.dup
      case @orientation
      when NORTH
        position[:y] = position[:y] + 1
      when SOUTH
        position[:y] = position[:y] - 1
      when EAST
        position[:x] = position[:x] + 1
      when WEST
        position[:x] = position[:x] - 1
      end
      @position = check_position(position)
    end
  end

  def check_position(position)
    [:x, :y].each { |k| position[k] = [[@lowerbound, position[k]].max, @upperbound].min }
    position
  end

  def turn(orientation)
    @orientation = (orientation > WEST) ? NORTH :
      (orientation < NORTH) ? WEST :
      orientation
  end

  def left
    turn(@orientation >> 1) if placed?
  end

  def right
    turn(@orientation << 1) if placed?
  end

  def report
    puts '%s,%s,%s' % [@position[:x], @position[:y], orientation] if placed?
  end

  def parse(command)
    case command
    when /PLACE (\d{1}),(\d{1}),(NORTH|SOUTH|EAST|WEST)/
      place(Integer($1), Integer($2), $3)
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
      robot = Robot2.new
      File.open(path, 'r') do |file|
        while command = file.gets
          robot.parse(command.strip)
        end
      end
    else
      puts "File not found: %s" % path
    end
  else
    robot = Robot2.new
    while command = $stdin.gets
      break if command.strip.empty?
      robot.parse(command)
    end
  end
end

