class String


  def symbolize
    self.downcase.gsub(" ", "_").gsub("/", "_").to_sym
  end

  def to_unique_string
    self.gsub(" ", "_") << rand(6**9).to_s
  end

  def to_csv
    self.split(", ")
  end

  def to_currency(delimiter=',')
    "$#{self.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse}"
  end

  def last(num)
    self[-num, num]
  end

end