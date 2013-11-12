require "test_helper"
require "story_fight/dsl"

class DSLTestWorld
  include StoryFight::DSL
end

TEST_WORLD = DSLTestWorld.new

TEST_WORLD.instance_eval do
  detail :Joe, :is => [ :actor, :man ]
  detail :Bob, :is => [ :actor, :armless_legless_man, :brave ]

  detail :FiddlersGreen, :is => [ :place, :peaceful ]
  detail :Battlefield, :is => [ :place, :dangerous ]

  story do
    detail :hero, :is => [ :actor, :brave ]
    detail :setting, :is => :place

    only_if { |details|
      hero = details[:hero]
      setting = details[:setting]

      setting.adjectives.include?(:dangerous) && !setting.adjectives.include?(:peaceful)
    }
  end
end

class SketchTest < MiniTest::Unit::TestCase

  def test_dsl_basic
    assert TEST_WORLD.get_details.select { |d| d.desc == :Joe }.size > 0, "Joe must be in test world!"
    assert TEST_WORLD.get_details.detect { |d| d.desc == :FiddlersGreen}.adjectives.include?(:place),
      "Fiddlers Green must be a place!"
  end

end
