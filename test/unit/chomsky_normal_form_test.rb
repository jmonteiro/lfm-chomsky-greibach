require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class ChomskyNormalFormTest < Test::Unit::TestCase
  context "Primitive FreeContextGrammar" do
    setup do
      @fcg = FreeContextGrammar.new(
        ['E'],
        ['+', '*', '[', ']', 'x'],
        { 'E' => ["E+E", "E*E", "[E]", "x"] },
        'E'
      )
    end
    
    should "accept convertion to ChomskyNormalForm" do
      assert @fcg.to_cnf
    end

    should "convert to ChomskyNormalForm and be as expected" do
      cnf = @fcg.to_cnf

      cnf_expected = ChomskyNormalForm.new(
        ['E', 'A', 'B', 'C', 'D', 'F', 'G', 'H'],
        ['+', '*', '[', ']', 'x'],
        {
          "A"=>["+"],
          "B"=>["*"],
          "C"=>["["],
          "D"=>["]"],
          "E"=>["EF", "EG", "CH", "x"],
          "F"=>["AE"],
          "G"=>["BE"],
          "H"=>["ED"]
        },
        'E'
      )
    
      assert_equal cnf_expected.productions, cnf.productions
    end
  end
end
