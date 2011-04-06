#! /usr/bin/ruby -s

require 'test/unit'
require 'lib/compiler'

class CompilerTest < Test::Unit::TestCase

  def test_parseWhiteSpace
    parser = Parser.new()
    state = parser.parse("    add(1,2)")
    assert_equal("    add(1,2)", state.ast[0].input )
    assert_equal(0...4, state.ast[0].interval )
  end

  def test_parseSymbol
    parser = Parser.new()
    state = parser.parse("    add(1,2)")
    assert_equal("    add(1,2)", state.ast[0].input )
    assert_equal(0...4, state.ast[0].interval )
    assert_equal(4...7, state.ast[1].interval )
  end

  def test_parseNumeric
    parser = Parser.new()
    state = parser.parse("   1   ")
    assert_equal(0...3, state.ast[0].interval )
    assert_equal(3...4, state.ast[1].interval )
    assert_equal(4...7, state.ast[2].interval )
  end

end
