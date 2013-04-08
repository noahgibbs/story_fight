require "test_helper"

class SketchTest < MiniTest::Unit::TestCase
  include StoryFight

  def setup
    @world = World.new
  end

  def test_truth
    assert true
  end
end
