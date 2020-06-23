module Actions
  def swastonize(text)
    return "Your text is too shory or too long" unless (2..10).includes?(text.size)

    word = text.chars.join(' ')
    result = ""
    whitespace = get_whitespace(text.size)
    big_whitespace = get_whitespace(text.size + 1)

    # Print the top line
    result += word
    result += whitespace
    result += word.chars[0]

    # Print top to middle lines
    (1..(text.size - 2)).each do |i|
      result += "\n"
      result += whitespace
      result += ' '
      result += text.reverse.chars[i]
      result += whitespace
      result += text.chars[i]
    end

    # Print the middle line
    result += "\n"
    result += word.reverse
    result = result.chars
    result.delete_at(-1)
    result = result.join
    result += word

    # Print middle to bottom lines
    (1..(text.size - 2)).each do |i|
      result += "\n"
      result += text.reverse.chars[i]
      result += whitespace
      result += text.chars[i]
    end

    # Print the bottom line
    result += "\n"
    result += word.chars[0]
    result += whitespace
    result += word.reverse

    "```\n#{result}```"
  end

  def get_whitespace(length : Int)
    init = ""
    (length * 2 - 3).times do 
      init += ' '
    end
    init
  end
end
