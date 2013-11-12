require "test_helper"
require "story_fight/generator"

class GeneratorTest < MiniTest::Unit::TestCase
  def setup
    @gen = StoryFight::Generator.new

    @gen.load_hash({
      "add_test" => [ "+", "foo", "bar" ],
      "or_test" => [ "||", "sam", "bob" ],
      "prob_test" => [ "||", [ 0.7, "joe"], [2.8, "dean"] ],
    })
  end

  def test_basics
    assert_equal "foobar", @gen.generate("add_test")

    ot_array = (1..100).map { @gen.generate("or_test") }
    assert ot_array.include?("sam"), "Or test must include first choice 'sam'!"
    assert ot_array.include?("bob"), "Or test must include second choice 'bob'!"
    assert ot_array.select { |i| i == "sam" }.size > 20, "Or test must generate at least 20 sams!"
    assert ot_array.select { |i| i == "bob" }.size > 20, "Or test must generate at least 20 bobs!"

    pt_array = (1..1000).map { @gen.generate("prob_test") }
    assert pt_array.include?("joe"), "Prob test must include first choice 'joe'!"
    assert pt_array.include?("dean"), "Prob test must include second choice 'dean'!"
    assert pt_array.select { |i| i == "joe" }.size > 10, "Prob test must generate at least 10 joes!"
    assert pt_array.select { |i| i == "dean" }.size > 60, "Prob test must generate at least 60 deans!"
  end
end
