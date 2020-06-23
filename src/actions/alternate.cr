module Actions
  def alternate(text : String)
    input = text.downcase.chars
    output = [] of Char
    k = 1
    input.each_with_index do |char, i|
      if char.upcase != char.downcase
        output << char.upcase if k.odd?
        output << char if k.even?
        k += 1
      else 
        output << char
      end
    end
    output.join
  end
end
