require "story_fight"

class Gameville::World
  def make_person(options = {})
    desc = options.delete(:name) || "Bob"
    adjectives = [ :person ] + (options[:is] || [])

    # Add to world
    new_detail(options.merge :desc => desc, :is => adjectives)
  end
end
