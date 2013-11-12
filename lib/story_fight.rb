require "story_fight/version"
require "story_fight/story"

# Inspiration:
#
# Imagine a crowded bar full of patrons.  Now imagine a computer
# representation of an intriguing bit about each patron, just a
# little backstory.  Now imagine somebody new comes in, human or
# computer-played.  The computer should be able to come up with
# various possible subplots involving them that don't contradict
# the known lore of the existing patrons.
#
# Basically, the bar can develop as it stories get more intricate, and
# as people come and go the bar will have a different set of stories
# available.
#
# Stories are built on, among others:
#
# * Facts about people
# * Relationships between people
# * Rumors and other current events


# Uses: I'm thinking this could become a little AI planning engine.
# AIs come up with goals to satisfy a variety of wants and choose
# between them.  This story engine is the planning engine to come up
# with goals, choose between them and so on.


module StoryFight

  # A StoryFight::Story is a class of stories such as "the hero faces
  # a hazard to rescue the romantic interest."  It can be instantiated
  # to make one or more instances, based on who is available to play
  # each role.
  #
  class Story
  end

  class World
    attr_reader :details

    def initialize(options = {})
      @details = []
    end

    def new_detail(options = {})
      @details << Detail.new(options)
      @details[-1]
    end

    # A Detail object can have specifics attached to it that are
    # germane to the story.
    #
    class Detail
      attr_reader :adjectives, :desc

      def initialize(options = {})
        @adjectives = [options.delete(:is) || []].flatten
        @desc = options.delete(:desc) || :NoDesc

        super()
      end
    end

    def step(time_delta = 1.0)
      raise "Unimplemented!"
    end
  end
end
