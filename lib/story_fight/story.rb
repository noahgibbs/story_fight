# A StoryFight::Story is a class of stories such as "the hero faces
# a hazard to rescue the romantic interest."  It can be instantiated
# to make one or more instances, based on who is available to play
# each role.
#
module StoryFight
  class Story
    attr_reader :details, :only_ifs

    def initialize(only_ifs = [], details = {})
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

        obj_list = world.details

        spec = [conditions[:is] || []].flatten

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
