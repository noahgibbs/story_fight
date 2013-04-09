require "story_fight/version"
require "story_fight/meta"

# Inspiration:
#
# Imagine a crowded bar full of patrons.  Now imagine a computer
# representation of an intriguing bit about each patron, just a
# little backstory.  Now imagine somebody new comes in, human or
# computer-played.  The computer should be able to come up with
# various possible subplots involving them that don't contradict
# the known lore of the existing patrons.
#
# Basically, the bar can develop as it stories get more intricate,
# and as people come and go the bar will have a different set
# of stories available.
#
# Stories are built on, among others:
#
# * Facts about people
# * Relationships between people
# * Rumors and other current events


module StoryFight

  # A StoryFight::Story is a class of stories such as "the hero faces
  # a hazard to rescue the romantic interest."  It can be instantiated
  # to make one or more instances, based on who is available to play
  # each role.
  #
  class Story
  end

  class World
    attr_reader :places, :actors, :things, :actions

    def initialize(options = {})
      @places = []
      @actors = []
      @things = []
      @actions = []
    end

    def new_actor(options = {})
      @actors << Actor.new(options)
      @actors[-1]
    end

    def new_thing(options = {})
      @things << Thing.new(options)
      @things[-1]
    end

    def new_place(options = {})
      @places << Place.new(options)
      @places[-1]
    end

    def new_action(options = {})
      @actions << Action.new(options)
      @actions[-1]
    end

    # A Specifiable object can have specifics attached to it that are
    # germane to the story.
    #
    module Specifiable
      attr_reader :adjectives, :desc

      def initialize(options = {})
        @adjectives = options.delete(:spec) || []
        @desc = options.delete(:desc) || :NoDesc

        super()
      end
    end

    class Place
      include Specifiable
    end

    class Actor
      include Specifiable
    end

    class Thing
      include Specifiable
    end

    class Action
      include Specifiable
    end
  end
end
