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
      if block_given?
        sd.instance_eval(&block)
      end

      if options[:with]
        options[:with].each do |key, val|
          detail_type = val.delete(:type)
          sd.with(detail_type, key, val)
        end
      end

      s = Story.new sd.details
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
end
