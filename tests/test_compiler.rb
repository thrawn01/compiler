#! /usr/bin/ruby -s

require 'test/unit'
require 'lib/compiler'

class CompilerTest < Test::Unit::TestCase

  def test_parseWhiteSpace
    state = Lexer.new().lex("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(:whitespace, state.syntax[0].type )
    assert_equal("    ", state.syntax[0].value )
  end

  def test_parseSymbol
    state = Lexer.new().lex("    add")
    assert_equal("    add", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(4...7, state.syntax[1].interval )
    assert_equal(:symbol, state.syntax[1].type )
    assert_equal("add", state.syntax[1].value )
    assert_equal("", state.syntax[2].value )
  end

  def test_parseNumeric
    state = Lexer.new().lex("   1   ")
    assert_equal(0...3, state.syntax[0].interval )
    assert_equal(3...4, state.syntax[1].interval )
    assert_equal(:number, state.syntax[1].type )
    assert_equal("1", state.syntax[1].value )
    assert_equal(4...7, state.syntax[2].interval )
  end

  def test_parseTokens
    state = Lexer.new().lex("    add(1,2)\n")
    assert_equal("    add(1,2)\n", state.syntax[0].input )
    assert_equal(0...4, state.syntax[0].interval )
    assert_equal(4...7, state.syntax[1].interval )
    assert_equal(7...8, state.syntax[2].interval )
    assert_equal(8...9, state.syntax[3].interval )
    assert_equal(9...10, state.syntax[4].interval )
    assert_equal(10...11, state.syntax[5].interval )
    assert_equal(11...12, state.syntax[6].interval )
    assert_equal(12...13, state.syntax[7].interval )
    assert_equal("\n", state.syntax[7].value )
  end

  def test_parser
    parser = Parser.new()
    state = parser.lex( "add(1,2)" )
    ast = parser.parse(state, "")

    assert(Function === ast[0])
    assert_equal("add", ast[0].name)
    assert_equal(2, ast[0].arguments.size)
    assert(Number === ast[0].arguments[0])
    assert(Number === ast[0].arguments[1])
  end

  def test_generator
    parser = Parser.new()
    ast = parser.parse(parser.lex( "add(1,2)" ), "")

    #g = Orange::Generator.new
    #g.preamble
    #g.function("test") do |gf|
        #str = gf.new_string(">> %d\n")
        #num = gf.new_number(7)
        #gf.assign("x", str)
        #gf.assign("y", num)
        #gf.call("printf", gf.load("x"), gf.load("y"))
    #end
    #g.call("test")
    #g.finish
    #puts g.inspect
    #g.run.inspect

end
