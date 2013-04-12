require "test_helper"
require "story_fight/dsl"

class DSLTest
  extend StoryFight::DSL

  # World decl must be first!
  world :TestWorld

  detail :desc => :Joe, :is => [ :actor, :man ]
  detail :desc => :Bob, :is => [ :actor, :armless_legless_man ]

  detail :desc => :FiddlersGreen, :is => :place
end

class SketchTest < MiniTest::Unit::TestCase

  def test_dsl_basic
    test_obj = DSLTest.new
    assert test_obj, "DSL allocation failed!"
  end

end
