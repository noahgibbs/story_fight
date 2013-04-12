require "test_helper"

class SketchTest < MiniTest::Unit::TestCase
  include StoryFight

  def setup
    @world = World.new

    @joe = @world.new_detail :desc => :Joe, :is => [ :actor, :man ]

    @sam = @world.new_detail :desc => :Sam, :is => [ :actor ]
    @bob = @world.new_detail :desc => :Bob, :is => [ :actor, :man, :green ]

    @burp = @world.new_detail :desc => :Burp, :is => [ :action, :involuntary ]
    @sneeze = @world.new_detail :desc => :Sneeze, :is => [ :action, :involuntary ]
    @whistle = @world.new_detail :desc => :Whistle, :is => [ :action, :musical ]

    @story1 = Story.new :the_man => { :is => [:actor, :man] },
      :action1 => { :is => [:action, :involuntary] }
    @story2 = Story.new :the_man => { :is => [:actor, :man] },
      :action1 => { :is => [:action, :involuntary] },
      :other_man => { :is => [:actor, :nobody] }
  end

  def test_basic_bind
    # We should get a binding of all "man" actors (joe, bob) to all
    # "involuntary" actions (burp, sneeze).

    # For the comparison, sort on actor desc then action desc
    assert_equal [
        { :the_man => @bob, :action1 => @burp },
        { :the_man => @bob, :action1 => @sneeze },
        { :the_man => @joe, :action1 => @burp },
        { :the_man => @joe, :action1 => @sneeze },
      ],
      @story1.bind(@world).sort_by { |binding| [binding[:the_man].desc, binding[:action1].desc] }
  end

  def test_no_result_bind
    assert_equal [], @story2.bind(@world)
  end
end
