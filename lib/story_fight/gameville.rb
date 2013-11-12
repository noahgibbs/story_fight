require "story_fight"

module Gameville
  class World < StoryFight::World
    attr :farmers
    attr :bakeries

    def initialize
      super

      @farmers = []
      @bakeries = []
    end

    def step(time = 1.0)
    end
  end
end
