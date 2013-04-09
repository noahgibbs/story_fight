require "test_helper"

class SketchTest < MiniTest::Unit::TestCase
  include StoryFight

  def setup
    @world = World.new

    @joe = @world.new_actor :desc => :Joe, :spec => [ :man ]

    @sam = @world.new_actor :desc => :Sam
    @bob = @world.new_actor :desc => :Bob, :spec => [ :man, :green ]

    @burp = @world.new_action :desc => :Burp, :spec => [ :involuntary ]
    @sneeze = @world.new_action :desc => :Sneeze, :spec => [ :involuntary ]
    @whistle = @world.new_action :desc => :Whistle, :spec => [ :musical ]

    @meta1 = Story::Meta.new :obj1 => { :desc => :the_man, :is => :actor, :spec => :man },
      :action1 => { :is => :action, :spec => :involuntary }
    @meta2 = Story::Meta.new :obj1 => { :desc => :the_man, :is => :actor, :spec => :man },
      :action1 => { :is => :action, :spec => :involuntary }, :obj2 => { :is => :actor, :spec => :nobody }
  end

  def test_basic_bind
    # We should get a binding of all "man" actors (joe, bob) to all
    # "involuntary" actions (burp, sneeze).

    # For the comparison, sort on actor desc then action desc
    assert_equal [
        { :obj1 => @bob, :action1 => @burp },
        { :obj1 => @bob, :action1 => @sneeze },
        { :obj1 => @joe, :action1 => @burp },
        { :obj1 => @joe, :action1 => @sneeze },
      ],
      @meta1.bind(@world).sort_by { |binding| [binding[:obj1].desc, binding[:action1].desc] }
  end

  def test_no_result_bind
    assert_equal [], @meta2.bind(@world)
  end
end
