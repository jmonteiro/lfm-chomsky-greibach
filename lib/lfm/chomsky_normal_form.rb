class ChomskyNormalForm < FreeContextGrammar

  def initialize(v, t, p, s)
    super(v, t, p, s)
  end

  def valid?
    @productions.values.each do |p|
      p.each do |vp|
        vp.scan
      end
    end
  end
end
