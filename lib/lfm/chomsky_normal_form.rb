class ChomskyNormalForm < FreeContextGrammar

  def initialize(v, t, p, s)
    super(v, t, p, s)
  end
  
  class <<self
    def from_fcg(fcg)
      fcg
    end
  end
end
