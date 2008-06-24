class FreeContextGrammar
  attr_accessor :vars, :terms, :productions, :start

  def initialize(v, t, p, s)
    @vars = v # ['E']
    @terms = t # ['+', '*', '[', ']', 'x']
    @productions = p # { 'E' => ["E+E", "E*E", "[E]", "x"] }
    @start = s # 'E'
  end

  def start_productions
    @productions[@start]
  end

  def to_cnf
     ChomskyNormalForm.from_fcg(self)
  end
end

