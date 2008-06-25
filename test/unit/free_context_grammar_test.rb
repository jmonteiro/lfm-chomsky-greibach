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
      assert_equal "A", @fcg.new_var
    end
    
    should "convert vars to the right side" do
      @fcg.vars_to_the_right_side
      assert_equal ["E", "A", "B", "C", "D", "F"].sort, @fcg.vars.sort
      assert_equal ["EAE", "EBE", "ECE", "DED", "F"].sort, @fcg.productions["E"].sort
    end

    should "find the right variable for a given term" do
      l = @fcg.new_var
      @fcg.terms << "z"
      @fcg.productions[l] = "z"
      assert_equal l, @fcg.find_var_by_term("z")
    end

    should "find or create the right variable for a given term" do
      l = @fcg.new_var
      assert_equal l, @fcg.find_or_create_var_by_term("z")
    end
    
    should "know if it is a var" do
      assert @fcg.is_a_var?("E")
      assert !@fcg.is_a_var?("*")
    end

    should "know if it is a term" do
      assert @fcg.is_a_term?("*")
      assert !@fcg.is_a_term?("E")
    end
  end
  
  should "substitute term with var from dictionary" do
    fcg = FreeContextGrammar.new [], [], {}, ''
    assert_equal "ACB", fcg.send("substitute_from_dictionary", {"A" => "x", "B" => "y"}, "xCy")
  end
end

