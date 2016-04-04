require './simple/robot2'

describe Robot2 do

  let(:robot) { Robot2.new }

  describe 'a shiny new robot' do

    it 'has an initial position of 0/0' do
      expect(robot.position).to eq({ x: 0, y: 0 })
    end

    it 'has an initial orientation of north' do
      expect(robot.orientation).to eq("NORTH")
    end

    it 'is not initially placed' do
      expect(robot).not_to be_placed
    end

    it 'cannot be placed out of bounds' do
      robot.place(10, 10, 'WEST')
      expect(robot.position).to eq({x: 4, y: 4})
    end

    it 'cannot be placed out of bounds' do
      robot.place(-2, -2, 'WEST')
      expect(robot.position).to eq({x: 0, y: 0})
    end

    describe 'which hasn\'t been placed' do

      it 'doesn\'t move' do
        robot.move
        expect(robot.position).to eq({ x: 0, y: 0 })
      end

      it 'doesn\'t turn left' do
        robot.left
        expect(robot.orientation).to eq('NORTH')
      end

      it 'doesn\'t turn right' do
        robot.right
        expect(robot.orientation).to eq('NORTH')
      end

      it 'cannot report its position' do
        expect { robot.report }.not_to output("0,0,NORTH").to_stdout
      end

    end

    describe 'which has been placed' do

      before :each do
        robot.place(1, 1, "SOUTH")
      end

      it 'can turn to the left' do
        robot.left
        expect(robot.orientation).to eq('EAST')
        robot.left
        expect(robot.orientation).to eq('NORTH')
      end

      it 'can turn to the right' do
        robot.right
        expect(robot.orientation).to eq('WEST')
        robot.right
        expect(robot.orientation).to eq('NORTH')
      end

      it 'can move to a valid square on the board' do
        robot.move
        expect(robot.position).to eq({ x: 1, y: 0 })
        expect(robot.orientation).to eq('SOUTH')
      end

      it 'cannot move off the bottom or the left side board' do
        10.times { robot.move }
        robot.right
        10.times { robot.move }
        expect(robot.position).to eq({ x: 0, y: 0 })
        expect(robot.orientation).to eq('WEST')
      end

      it 'cannot move off the top or right side of the board' do
        robot.place(0, 0, 'NORTH')
        10.times { robot.move }
        robot.right
        10.times { robot.move }
        expect(robot.position).to eq({ x: 4, y: 4 })
        expect(robot.orientation).to eq('EAST')
      end

      it 'can be re-placed' do
        robot.move
        robot.place(3, 3, 'WEST')
        expect(robot.position).to eq({ x: 3, y: 3 })
        expect(robot.orientation).to eq('WEST')
      end

      it 'can report it\'s position' do
        expect { robot.report }.to output("1,1,SOUTH\n").to_stdout
      end

    end

    describe 'the robot command parser' do

      before :each do
        robot.place(1, 1, "SOUTH")
      end

      it 'understands how to turn left' do
        robot.parse('LEFT')
        expect(robot.position).to eq({ x: 1, y: 1 })
        expect(robot.orientation).to eq('EAST')
      end

      it 'understands how to turn right' do
        robot.parse('RIGHT')
        expect(robot.position).to eq({ x: 1, y: 1 })
        expect(robot.orientation).to eq('WEST')
      end

      it 'understands how to move' do
        robot.parse('MOVE')
        expect(robot.position).to eq({ x: 1, y: 0 })
        expect(robot.orientation).to eq('SOUTH')
      end

      it 'understands how to be placed' do
        robot.parse('PLACE 2,4,EAST')
        expect(robot.position).to eq({ x: 2, y: 4 })
        expect(robot.orientation).to eq('EAST')
      end

      it 'understands how to report its position' do
        expect { robot.parse('REPORT') }.to output("1,1,SOUTH\n").to_stdout
      end

      it 'ignored nonsense commands not in its limited vocabulary' do
        robot.parse('leeft') # misspelled
        robot.parse('right') # lowercase
        expect(robot.position).to eq({ x: 1, y: 1 })
        expect(robot.orientation).to eq('SOUTH')
      end

    end

  end

end

