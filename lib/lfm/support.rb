class String
  def each_letter(sep = '')
    self.split(sep).each { |l| yield l }
  end
end

