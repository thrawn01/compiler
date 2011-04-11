#! /usr/bin/ruby -s

require 'test/unit'
require 'lib/compiler'

class CompilerTest < Test::Unit::TestCase

  def test_parseWhiteSpace
    lexer = Lexer.new()
    state = lexer.parse("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(:whitespace, state.syntax[0].type )
  end

  def test_parseSymbol
    lexer = Lexer.new()
    state = lexer.parse("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(4...7, state.syntax[1].interval )
    assert_equal(:symbol, state.syntax[1].type )
  end

  def test_parseNumeric
    lexer = Lexer.new()
    state = lexer.parse("   1   ")
    assert_equal(0...3, state.syntax[0].interval )
    assert_equal(3...4, state.syntax[1].interval )
    assert_equal(:number, state.syntax[1].type )
    assert_equal(4...7, state.syntax[2].interval )
  end

  def test_parseSymbol
    lexer = Lexer.new()
    state = lexer.parse("    add(1,2)")
    assert_equal("    add(1,2)", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(4...7, state.syntax[1].interval )
    assert_equal(7...8, state.syntax[2].interval )
    assert_equal(8...9, state.syntax[3].interval )
    assert_equal(9...10, state.syntax[4].interval )
    assert_equal(10...11, state.syntax[5].interval )
  end

  def test_parser
    #parser = Parser.new()
    #lexer = Lexer.new()
    #ast = parser.parse(lexer, "add(1,2)")

    #assert(Function === ast)
    #assert_equal("add", ast.name)
    #assert_equal(2, ast.arguments.size)
    #assert(Number === ast.arguments[0])
    #assert(Number === ast.arguments[1])

  end
end
