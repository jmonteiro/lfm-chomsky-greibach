require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class FreeContextGrammarTest < Test::Unit::TestCase
  context "Primitive FreeContextGrammar" do
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

    should "find the right variable for a given term" do
      l = @fcg.new_var
      @fcg.terms << "z"
      @fcg.productions[l] = "z"
      assert_equal l, @fcg.find_var_by_content("z")
    end

    should "find or create the right variable for a given term" do
      l = @fcg.new_var
      assert_equal l, @fcg.find_or_create_var_by_content("z")
    end
    
    should "know if it is a var" do
      assert @fcg.is_a_var?("E")
      assert !@fcg.is_a_var?("*")
    end

    should "know if it is a term" do
      assert @fcg.is_a_term?("*")
      assert !@fcg.is_a_term?("E")
    end
    
    should "convert vars to the right side" do
      @fcg.vars_to_the_right_in_production
      assert_equal ["E", "A", "B", "C", "D"].sort, @fcg.vars.sort
      assert_equal ["EAE", "EBE", "CED", "x"].sort, @fcg.productions["E"].sort
    end
  end

  context "FreeContextGrammar after vars_to_the_right_in_productions" do
    setup do
      @fcg = FreeContextGrammar.new(
        ['E', 'A', 'B', 'C', 'D'],
        ['+', '*', '[', ']', 'x'],
        {
          'E' => ["EAE", "EBE", "CED", "x"],
          'A' => ['+'],
          'B' => ['*'],
          'C' => ['['],
          'D' => [']']
        },
        'E'
      )
    end

    should "transform tripe-rules productions with, at maximum, two vars each" do
      @fcg.max_last_two_vars_in_productions
      productions_expected = {"A"=>["+"], "B"=>["*"], "C"=>["["], "D"=>["]"], "E"=>["EF", "EG", "CH", "x"], "F"=>"AE", "G"=>"BE", "H"=>"ED"}

      assert_equal productions_expected, @fcg.productions
    end

    should "transform quintuple-rules productions with, at maximum, two vars each" do
      @fcg.productions["E"] << "CEAD"
      @fcg.max_last_two_vars_in_productions
      productions_expected = {"A"=>["+"], "B"=>["*"], "C"=>["["], "D"=>["]"], "E"=>["EF", "EG", "CH", "x", "CI"], "F"=>"AE", "G"=>"BE", "H"=>"ED", "I" => "EJ", "J" => "AD"}

      #assert_equal productions_expected.keys.sort, @fcg.vars.sort
      assert_equal productions_expected, @fcg.productions
    end
  end
end

