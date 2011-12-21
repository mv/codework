require "rubygems"
require "treetop"

dir = File.expand_path(File.dirname(__FILE__))
load_grammar File.expand_path("#{dir}/sql_parser")

class SqlParser::ItemsNode < Treetop::Runtime::SyntaxNode
  def values
    items.values.unshift(item.value)
  end
end

class SqlParser::ItemNode < Treetop::Runtime::SyntaxNode
  def values
    [value]
  end
  
  def value
    text_value.to_sym
  end
end
