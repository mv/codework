#
# Ref: http://stackoverflow.com/questions/713559/how-do-i-tokenize-this-string-in-ruby
#

require 'strscan'

def test_parse
  text = %{Children^10 Health "sanitation management"^5}
  expected = [{:keywords=>"children", :boost=>10}, {:keywords=>"health", :boost=>nil}, {:keywords=>"sanitation management", :boost=>5}]


  assert_equal(expected, parse(text))
end

def parse(text)
  @input = StringScanner.new(text)

  output = []

  while keyword = parse_string || parse_quoted_string
    output << {
      :keywords => keyword,
      :boost => parse_boost
    }
    trim_space
  end

  output
end

def parse_string
  if @input.scan(/\w+/)
    @input.matched.downcase
  else
    nil
  end
end

def parse_quoted_string
  if @input.scan(/"/)
    str = parse_quoted_contents
    @input.scan(/"/) or raise "unclosed string"
    str
  else
    nil
  end
end

def parse_quoted_contents
  @input.scan(/[^\\"]+/) and @input.matched
end

def parse_boost
  if @input.scan(/\^/)
    boost = @input.scan(/\d+/)
    raise 'missing boost value' if boost.nil?
    boost.to_i
  else
    nil
  end
end

def trim_space
  @input.scan(/\s+/)
end


