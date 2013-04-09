require "story_fight/version"

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


# Op: FindStoriesForFacts
# Given a bunch of current established facts and a set of
# candidate meta-stories, we need a bunch of story instances
# that *could* apply.

module StoryFight

  module Story
    # A detail is a person, place or thing that affects the story
    # somehow.
    #
    class Detail
    end

    # A story instance is a story with some or all of the details
    # frozen to known Places, Actors or Things.
    #
    class Instance
    end

    # A MetaStory is a class of stories such as "the hero faces a
    # hazard to rescue the romantic interest."  It can be instantiated
    # to make one or more Instances, based on who is available to play
    # each role.
    #
    class Meta
      attr_reader :details

      def initialize(details = {})
        @details = details
      end

      def bind(world, bound_details = {})
        # Everything matches, just return it
        if bound_details.keys.sort == @details.keys.sort
          return [ bound_details ]
        end

        # This isn't really an "each".  It's actually
        # a "pick the first unbound detail."
        #
        @details.each do |name, conditions|
          # Assume existing bindings are correct
          next if bound_details[name]

          method_name = conditions[:is].to_s + "s"
          obj_list = world.send(method_name)

          spec = [conditions[:spec] || []].flatten

          did_bind = false
          bindings = []
          obj_list.each do |candidate|
            # If we got a match on "spec"...
            if (candidate.adjectives & spec).size == spec.size
              did_bind = true
              # Intentionally copy, not modify, into new_bound
              new_bound = bound_details.merge(name => candidate)
              bindings += bind(world, new_bound)
            end
          end

          return bindings if did_bind

          # Otherwise, no match
          return []
        end
      end
    end
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
