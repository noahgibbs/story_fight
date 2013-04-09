module StoryFight
  class Story
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
