module Actions
  def show_exceptions_cr(code : String)
    "begin
    #{code}
  rescue e
    puts e.message
  end"
  end
  
  def run_code_cr(code : String)
    puts `echo '#{show_exceptions_cr(code)}' > code.cr`
    puts `crystal code.cr > result`
    result = File.read("./result")
    result = result.strip.empty? ? "no output, log to the console" : result
  end

  def show_exceptions_rb(code : String)
  "begin
    #{code}
  rescue => e
    puts e
  end"
  end
  
  def run_code_rb(code : String)
    puts `echo '#{show_exceptions_rb(code)}' > code.rb`
    puts `ruby code.rb > result`
    result = File.read("./result")
    result = result.strip.empty? ? "`no output, log to the console`" : result
  end
end
