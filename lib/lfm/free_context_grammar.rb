class FreeContextGrammar
  attr_accessor :vars, :terms, :productions, :start

  def initialize(v, t, p, s)
    @vars = v # ['E']
    @terms = t # ['+', '*', '[', ']', 'x']
    @productions = p # { 'E' => ["E+E", "E*E", "[E]", "x"] }
    @start = s # 'E'
  end

  def start_productions
    productions[start]
  end
  
  def next_letter_avaliable
    ('A'..'Z').to_a.each do |letter|
      return letter unless vars.include?(letter)
    end
  end
  
  def add_next_letter_avaliable
    next_letter = next_letter_avaliable
    vars << next_letter
    next_letter
  end
  
  def vars_to_the_right_side
    letters = {}
    terms.each do |t|
      letters.merge({add_next_letter_avaliable => t})
    end
    
    new_productions = letters
    productions.each do |k, v|
      new_productions[k] = v.collect do |content|
        content = substitute_from_dictionary(letters, content)
      end
    end
    productions = new_productions
    
    self
  end

  def to_cnf
    ChomskyNormalForm.from_fcg(self)
  end
  
  protected
  def substitute_from_dictionary(dic, string)
    dic.each { |k, v| string.gsub!(v, k) }
    string
  end
end