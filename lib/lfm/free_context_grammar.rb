class FreeContextGrammar
  attr_accessor :terms, :productions, :start

  def initialize(v, t, p, s)
    vars = v # ['E'], é descartado pois conhece-as dinamicamente com base em productions
    @terms = t # ['+', '*', '[', ']', 'x']
    @productions = p # { 'E' => ["E+E", "E*E", "[E]", "x"] }
    @start = s # 'E'
  end

  # Simplification: Clean empty
  def clean_empty
    each_rule_with_var do |var, rule|
      if !(rule == empty) && rule.size > 1
        rule.each_letter do |l|
          if is_a_var?(l) && leads_to_empty.include?(l)
            productions[var] << rule.clone.gsub(l, '') 
          end
        end
      end
    end
    delete_vars_that_leads_direct_to_empty
  end

  def leads_to_empty
    list = []
    each_rule_with_var do |var, rule|
      rule.each_letter do |l|
        if is_a_var?(l) && !list.include?(l) && leads_direct_to_empty.include?(l)
          list << var
        end
      end
    end
    list = (list + leads_direct_to_empty).uniq
    return list
  end

  def leads_direct_to_empty
    list = []
    each_rule_with_var do |var, rule|
      if rule == empty
        list << var unless list.include?(var)
      end
    end
    return list
  end

  def delete_vars_that_leads_direct_to_empty
    leads_direct_to_empty.each do |v|
      productions.delete(v) if productions[v].size == 1
    end
  end

  # Simplification: Clean to direct productions
  def clean_to_direct_productions
    each_rule_with_var do |var, rule|
      if rule.size == 1 && is_a_var?(rule)
        productions[rule].each do |direct_terms|
          productions[var] << direct_terms
        end
        
        productions.delete(rule)
        productions[var].delete(rule)
        
        return clean_to_direct_productions
      end
    end
  end
  
  # Returns the next var avaliable
  def new_var
    ('A'..'Z').to_a.each do |letter|
      return letter unless vars.include?(letter)
    end
  end
  
  def vars_to_the_right_in_production
    each_rule do |rule|
      if rule.size >= 2
        rule.each_letter { |l| rule.gsub!(l, find_or_create_var_by_content(l)) if is_a_term?(l) }
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  def max_last_two_vars_in_productions
    each_rule do |rule|
      if rule.size >= 3
        v = find_or_create_var_by_content(rule[1, rule.size])
        rule[1, rule.size] = v
        return max_last_two_vars_in_productions
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  # TODO TEST!!!
  def each_rule
    vars.each do |var|
      productions[var].size.times do |i|
        yield productions[var][i]
      end
    end
  end
  
  # TODO rewrite in a Ruby way (clean code)
  # TODO TEST!!!
  def each_rule_with_var
    vars.each do |var|
      productions[var].size.times do |i|
        yield var, productions[var][i]
      end
    end
  end

  def empty
    '&'
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

