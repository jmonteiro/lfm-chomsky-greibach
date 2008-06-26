class ChomskyNormalForm < FreeContextGrammar

  def initialize(v, t, p, s)
    super(v, t, p, s)
  end
  
  class <<self
    def from_fcg(fcg)
      chomsky = ChomskyNormalForm.new(fcg.vars, fcg.terms, fcg.productions, fcg.start)
      
      # simplifications
      chomsky.clean_to_direct_productions
      
      chomsky.vars_to_the_right_in_production
      chomsky.max_last_two_vars_in_productions
      
      return chomsky
    end
  end
end
