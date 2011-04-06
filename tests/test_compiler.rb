#! /usr/bin/ruby -s

require 'test/unit'
require 'lib/compiler'

class CompilerTest < Test::Unit::TestCase

  def test_getToken
    parser = Parser.new()
    ast = parser.parse("    add(1,2)")
    assert_equal(ast.input, "    add(1,2)" )
    assert_equal(ast.interval, 0...4 )
  end

end
