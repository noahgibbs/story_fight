module StoryFight
  module DSL
    def world(options = {})
      @cur_world = World.new options
    end

    def ensure_cur_world
      world(:desc => :DefaultWorld) unless @cur_world
    end

    def detail(description, options = {})
      ensure_cur_world
      raise "Use a description, not just options!" if description.is_a?(Hash)
      @cur_world.new_detail options.merge(:desc => description)
    end

    def story(options = {}, &block)
      sd = StoryDSL.new
      raise "Must provide a block to story!" unless block_given?

      sd.instance_eval(&block)

      s = Story.new sd.get_only_ifs, sd.get_details
      @cur_world.add_story s
      @stories ||= []
      @stories << s
      s
    end

    def get_world
      @cur_world
    end

    def get_details
      @cur_world.details
    end

    def get_stories
      @cur_world.stories
    end
  end

  # Used by story blocks in DSL
  class StoryDSL
    include StoryFight::DSL

    def get_only_ifs
      @only_ifs || []
    end

    def only_if(&block)
      @only_ifs ||= []
      @only_ifs << block
    end
  end
end
