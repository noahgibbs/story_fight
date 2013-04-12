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

      Story.new sd.details
    end
  end

  class StoryDSL
    attr_reader :details

    WITH_FIELDS = [ :must_be ]
    def with(detail_type, desc, options = {})
      bad_fields = options.keys - WITH_FIELDS
      unless bad_fields.empty?
        raise "Unknown :with fields: #{bad_fields.inspect}!"
      end

      @details ||= []
      @details.push desc => { :is => options[:must_be] || {} }
    end
  end
end
