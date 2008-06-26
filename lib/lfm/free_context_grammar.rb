class FreeContextGrammar
  attr_accessor :terms, :productions, :start

  def initialize(v, t, p, s)
    vars = v # ['E'], é discartado pois utiliza dinamicamente com base em productions
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
  
  def vars_to_the_right_in_production
    each_rule(:min => 2) do |rule|
      rule.each_letter { |l| rule.gsub!(l, find_or_create_var_by_content(l)) if is_a_term?(l) }
    end
  end

  def max_last_two_vars_in_productions
    each_rule(:min => 3) do |rule|
      v = find_or_create_var_by_content(rule[1, rule.size])
      rule[1, rule.size] = v
      while productions[v].first.size >= 3
        rule = productions[v].first
        v = find_or_create_var_by_content(rule[1, rule.size])
        rule[1, rule.size] = v
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  # TODO TEST!!!
  def each_rule(options = {})
    options[:min] ||= 2

    vars.each do |var|
      productions[var].size.times do |i|
        if productions[var][i].size >= options[:min]
          yield productions[var][i]
        end
      end
    end
  end

  def find_var_by_content(q)
    productions.each do |var, content|
      return var if content[0] == q or content == q
    end
    return false
  end 

  def find_or_create_var_by_content(q)
    unless v = find_var_by_content(q)
      v = new_var
      productions[v] = [q]
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
end

