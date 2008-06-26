class FreeContextGrammar
  attr_accessor :terms, :productions, :start

  def initialize(v, t, p, s)
    @vars = v # ['E']
    @terms = t # ['+', '*', '[', ']', 'x']
    @productions = p # { 'E' => ["E+E", "E*E", "[E]", "x"] }
    @start = s # 'E'
  end

  def start_productions
    productions[start]
  end
  
  # Returns the next var avaliable
  def new_var
    ('A'..'Z').to_a.each do |letter|
      return letter unless vars.include?(letter)
    end
  end
  
  def vars_to_the_right_side
    productions.each do |var, rule|
      if rule.size <= 2
        rule.split('').each do |l|
          productions[var].gsub!(l, find_or_create_var_by_term(l)) if is_a_term?(l)
        end
      end
    end
    
    self
  end
  
  def find_var_by_term(q)
    productions.each do |var, term|
      return var if term == q
    end
    return false
  end 

  def find_or_create_var_by_term(q)
    unless v = find_var_by_term(q)
      v = new_var
      productions[v] = q
    end
    return v
  end

  def to_cnf
    ChomskyNormalForm.from_fcg(self)
  end

  def is_a_var?(q)
    vars.include?(q)
  end
  
  def is_a_term?(q)
    terms.include?(q)
  end

  def vars
    productions.keys
  end

  protected
  def substitute_from_dictionary(dic, string)
    dic.each { |k, v| string.gsub!(v, k) }
    string
  end
end
