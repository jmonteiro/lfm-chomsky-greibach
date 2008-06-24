require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class ChomskyNormalFormTest < Test::Unit::TestCase
  context "First FreeContextGrammar example" do
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
=begin
    should "convert and be as expected" do
      cnf = @fcg.clone.to_cnf

      cnf_expected = ChomskyNormalForm.new(
        ['E', 'C+', 'C*', 'C[', 'C]', 'D1', 'D2', 'D3'],
        ['+', '*', '[', ']', 'x'],
        {
          'E' => ['ED1', 'ED2', 'C[D3', 'x'],
          'D1' => ['C+E'], 'D2' => ['C*E'], 'D3' => ['EC]'],
          'C+' => ['+'], 'C*' => ['*'], 'C[' => ['['], 'C]' => [']']
        },
        'E'
      )
    
      assert_equal cnf_expected.productions.keys.sort, cnf.productions.keys.sort
      assert_equal cnf_expected.productions.values.sort, cnf.productions.values.sort
    end
=end
  end
end
