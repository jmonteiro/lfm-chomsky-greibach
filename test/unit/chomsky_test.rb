require 'test/unit'
require 'rubygems'
require 'shoulda'
require File.dirname(__FILE__) + '/../../lib/chomsky'

class ChomskyTest < Test::Unit::TestCase
  should "resolv example 10 from the book" do
    glc = FreeContextGrammar.new(
      [:e],
      ['+', '*', '[', ']', 'x'],
      { :e => [":e+:e", ":e*:e", "[:e]", "x"] },
      :e
    )
    fnc_converted = glc.to_fnc

    fnc_expected = ChomskyNormalForm.new(
      [:e, :cp, :cm, :cc, :cv, :da, :db, :dc],
      ['+', '*', '[', ']', 'x'],
      {
        :e => [""]
      },
      :e
    )
    
    assert_equal fnc_expected, fnc_converted
  end
end
