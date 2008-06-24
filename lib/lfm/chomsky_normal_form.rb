class ChomskyNormalForm < FreeContextGrammar

  def initialize(v, t, p, s)
    super(v, t, p, s)
  end
  
  class <<self
    def from_fcg(fcg)
      c = ChomskyNormalForm.new(fcg.vars, fcg.terms, fcg.productions, fcg.start)
      # c.simplify
      c.vars_to_the_right_side
      # c.only_to_vars_in_the_right_side
      
      return c
    end
  end
end
