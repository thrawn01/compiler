#! /usr/bin/ruby -s

require 'test/unit'
require 'lib/compiler'

class CompilerTest < Test::Unit::TestCase

  def test_parseWhiteSpace
    lexer = Lexer.new()
    state = lexer.parse("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
  end

  def test_parseSymbol
    lexer = Lexer.new()
    state = lexer.parse("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(4...7, state.syntax[1].interval )
  end

  def test_parseNumeric
    lexer = Lexer.new()
    state = lexer.parse("   1   ")
    assert_equal(0...3, state.syntax[0].interval )
    assert_equal(3...4, state.syntax[1].interval )
    assert_equal(4...7, state.syntax[2].interval )
  end

  #def test_parser
    #parser = Parser.new()
    #lexer = Lexer.new()
    #ast = parser.parse(lexer, "add(1,2)")

    #assert(Call === ast)
    #assert_equal("add", ast.name)
    #assert_equal(2, ast.arguments.size)
    #assert(Fixnum === ast.arguments[0])
    #assert(Fixnum === ast.arguments[1])

  #end
end
