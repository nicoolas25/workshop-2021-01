#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'

ADVANCE = {
  north: [0, 1],
  south: [0, -1],
  east: [1, 0],
  west: [-1, 0],
}
TURN_LEFT = { north: :west, south: :east, east: :north, west: :south }
TURN_RIGHT = { north: :east, south: :west, east: :south, west: :north }

def magic((x,y,orientation), sequence_of_commands)
  # ...
  # return final_position
  sequence_of_commands.each_char do |command|
    x,y,orientation = case command
    when "A"
      diff_x, diff_y = ADVANCE.fetch(orientation)
      [x + diff_x, y + diff_y, orientation]
    when "L"
      [x, y, TURN_LEFT.fetch(orientation)]
    when "R"
      [x, y, TURN_RIGHT.fetch(orientation)]
    end
  end
  return x,y,orientation
end

class RobotTurningTest < Minitest::Test
  def test_readme
    final_position = magic([7, 3, :north], "RAALAL")
    assert_equal([9, 4, :west], final_position)
  end

  def test_turn_left_from_north
    final_position = magic([7, 3, :north], "L")
    assert_equal([7, 3, :west], final_position)
  end

  def test_turn_left_from_south
    final_position = magic([7, 3, :south], "L")
    assert_equal([7, 3, :east], final_position)
  end

  def test_turn_left_from_east
    final_position = magic([7, 3, :east], "L")
    assert_equal([7, 3, :north], final_position)
  end

  def test_turn_left_from_west
    final_position = magic([7, 3, :west], "L")
    assert_equal([7, 3, :south], final_position)
  end

  def test_advance_north
    final_position = magic([7, 3, :north], "A")
    assert_equal([7, 4, :north], final_position)
  end

  def test_advance_south
    final_position = magic([7, 3, :south], "A")
    assert_equal([7, 2, :south], final_position)
  end

  def test_advance_east
    final_position = magic([7, 3, :east], "A")
    assert_equal([8, 3, :east], final_position)
  end

  def test_advance_west
    final_position = magic([7, 3, :west], "A")
    assert_equal([6, 3, :west], final_position)
  end

  def test_advance_twice_west
    final_position = magic([7, 3, :west], "AA")
    assert_equal([5, 3, :west], final_position)
  end
end

__END__
  def test_robot_bearing
    [:east, :west, :north, :south].each do |direction|
      robot.orient(direction)
      assert_equal direction, robot.bearing
    end
  end

  def test_invalid_robot_bearing
    skip
    assert_raises ArgumentError do
      robot.orient(:crood)
    end
  end

  def test_turn_right_from_north
    skip
    robot.orient(:north)
    robot.turn_right
    assert_equal :east, robot.bearing
  end

  def test_turn_right_from_east
    skip
    robot.orient(:east)
    robot.turn_right
    assert_equal :south, robot.bearing
  end

  def test_turn_right_from_south
    skip
    robot.orient(:south)
    robot.turn_right
    assert_equal :west, robot.bearing
  end

  def test_turn_right_from_west
    skip
    robot.orient(:west)
    robot.turn_right
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_north
    skip
    robot.orient(:north)
    robot.turn_left
    assert_equal :west, robot.bearing
  end

  def test_turn_left_from_east
    skip
    robot.orient(:east)
    robot.turn_left
    assert_equal :north, robot.bearing
  end

  def test_turn_left_from_south
    skip
    robot.orient(:south)
    robot.turn_left
    assert_equal :east, robot.bearing
  end

  def test_turn_left_from_west
    skip
    robot.orient(:west)
    robot.turn_left
    assert_equal :south, robot.bearing
  end

  def test_robot_coordinates
    skip
    robot.at(3, 0)
    assert_equal [3, 0], robot.coordinates
  end

  def test_other_robot_coordinates
    skip
    robot.at(-2, 5)
    assert_equal [-2, 5], robot.coordinates
  end

  def test_advance_when_facing_north
    skip
    robot.at(0, 0)
    robot.orient(:north)
    robot.advance
    assert_equal [0, 1], robot.coordinates
  end

  def test_advance_when_facing_east
    skip
    robot.at(0, 0)
    robot.orient(:east)
    robot.advance
    assert_equal [1, 0], robot.coordinates
  end

  def test_advance_when_facing_south
    skip
    robot.at(0, 0)
    robot.orient(:south)
    robot.advance
    assert_equal [0, -1], robot.coordinates
  end

  def test_advance_when_facing_west
    skip
    robot.at(0, 0)
    robot.orient(:west)
    robot.advance
    assert_equal [-1, 0], robot.coordinates
  end
end

class RobotSimulatorTest < Minitest::Test
  def simulator
    @simulator ||= Simulator.new
  end

  def test_instructions_for_turning_left
    skip
    assert_equal [:turn_left], simulator.instructions('L')
  end

  def test_instructions_for_turning_right
    skip
    assert_equal [:turn_right], simulator.instructions('R')
  end

  def test_instructions_for_advancing
    skip
    assert_equal [:advance], simulator.instructions('A')
  end

  def test_series_of_instructions
    skip
    commands = [:turn_right, :advance, :advance, :turn_left]
    assert_equal commands, simulator.instructions('RAAL')
  end

  def test_instruct_robot
    skip
    robot = Robot.new
    simulator.place(robot, x: -2, y: 1, direction: :east)
    simulator.evaluate(robot, 'RLAALAL')
    assert_equal [0, 2], robot.coordinates
    assert_equal :west, robot.bearing
  end

  def test_instruct_many_robots # rubocop:disable Metrics/MethodLength
    skip
    robot1 = Robot.new
    robot2 = Robot.new
    robot3 = Robot.new
    simulator.place(robot1, x: 0, y: 0, direction: :north)
    simulator.place(robot2, x: 2, y: -7, direction: :east)
    simulator.place(robot3, x: 8, y: 4, direction: :south)
    simulator.evaluate(robot1, 'LAAARALA')
    simulator.evaluate(robot2, 'RRAAAAALA')
    simulator.evaluate(robot3, 'LAAARRRALLLL')

    assert_equal [-4, 1], robot1.coordinates
    assert_equal :west, robot1.bearing

    assert_equal [-3, -8], robot2.coordinates
    assert_equal :south, robot2.bearing

    assert_equal [11, 5], robot3.coordinates
    assert_equal :north, robot3.bearing
  end

