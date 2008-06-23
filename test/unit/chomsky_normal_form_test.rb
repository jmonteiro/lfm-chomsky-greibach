require 'test/unit'
require 'rubygems'
require 'shoulda'
require File.dirname(__FILE__) + '/../../lib/free_context_grammar'
require File.dirname(__FILE__) + '/../../lib/chomsky_normal_form'

class ChomskyNormalFormTest < Test::Unit::TestCase

  context 'Invalid CNF' do
    should 'be invalid' do
      cnf = ChomskyNormalForm.new(
        ['E'],
        ['+', '*', '[', ']', 'x'],
        { 'E' => ["E+E", "E*E", "[E]", "x"] },
        'E'
      )
      assert !cnf.valid?
    end
  end

  context 'Valid CNF' do
    should 'be valid' do
      cnf = ChomskyNormalForm.new(
        ['A', 'B'],
        ['a', 'b', 'c'],
        { 'A' => ['AB', 'B'], 'B' => ['a'] },
        'A'
      )
      assert cnf.valid?
    end
  end
=begin
  should "resolv example 10 from the book" do
    fcg = FreeContextGrammar.new(
      ['E'],
      ['+', '*', '[', ']', 'x'],
      { 'E' => ["E+E", "E*E", "[E]", "x"] },
      'E'
    )
    fnc_converted = fcg.to_fnc

    fnc_expected = ChomskyNormalForm.new(
      ['E', 'C+', 'C*', 'C[', 'C]', 'D1', 'D2', 'D3']
      ['+', '*', '[', ']', 'x'],
      {
        'E' => ['ED1', 'ED2', 'C[D3', 'x'],
        'D1' => ['C+E'], 'D2' => ['C*E'], 'D3' => ['EC]'],
        'C+' => ['+'], 'C*' => ['*'], 'C[' => ['['], 'C]' => [']']
      },
      'E'
    )
    
    assert_equal fnc_expected, fnc_converted
  end
=end
end
