require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class FreeContextGrammarTest < Test::Unit::TestCase
  context "The first free context grammar example" do
    setup do
      @fcg = FreeContextGrammar.new(
        ['E'],
        ['+', '*', '[', ']', 'x'],
        { 'E' => ["E+E", "E*E", "[E]", "x"] },
        'E'
      )
    end

    should "accept free context grammar object" do
      assert @fcg
    end

    should "get the start production" do
      assert_equal @fcg.start_productions, ["E+E", "E*E", "[E]", "x"]
    end
  end
end

