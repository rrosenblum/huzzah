class String

  def symbolize
    downcase.gsub(' ', '_').gsub('/', '_').to_sym
  end

  def to_unique_string
    gsub(' ', '_') << rand(6**9).to_s
  end

  def to_csv
    split(', ')
  end

  def to_currency(delimiter = ',')
    "$#{reverse.gsub(/([0-9]{3}(?=([0-9])))/, "\\1#{delimiter}").reverse}"
  end

  def last(num)
    self[-num, num]
  end

end
