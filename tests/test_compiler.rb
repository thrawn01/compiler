require 'test/unit'

class CompilerTest < Test::Unit::TestCase

  def test_getToken
    compiler = Compiler.new()
    tokenType = compiler.getToken("add(1,2)")
    assert_equal(:symbol, token)
    assert_equal("add", compiler.symbol)
  end

end
