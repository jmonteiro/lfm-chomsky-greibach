require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

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
      assert_equal @fcg.start_productions.sort, ["E+E", "E*E", "[E]", "x"].sort
    end
    
    should "find the next letter avaliable to variable" do
      assert_equal "A", @fcg.next_letter_avaliable
      
      @fcg.vars << @fcg.next_letter_avaliable
      assert_equal "B", @fcg.next_letter_avaliable
    end
    
    should "accept one more variable" do
      @fcg.add_next_letter_avaliable
      assert_equal "B", @fcg.next_letter_avaliable
    end
    
    should "convert vars to the right side" do
      @fcg.vars_to_the_right_side
      assert_equal ["E", "A", "B", "C", "D", "F"].sort, @fcg.vars.sort
      assert_equal ["EAE", "EBE", "ECE", "DED", "F"].sort, @fcg.productions["E"].sort
    end
  end
  
  should "substitute term with var from dictionary" do
    fcg = FreeContextGrammarTest.new
    assert_equal "ACB", fcg.send("substitute_from_dictionary", {"A" => "x", "B" => "y"}, "xCy")
  end
end

