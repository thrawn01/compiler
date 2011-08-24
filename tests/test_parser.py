#!/usr/bin/python

from llvm import *
from llvm.core import *
import unittest, logging, sys
from ollie import Lexer,Parser,FunctionCall,Number,Generator

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
log = logging.getLogger( "test" )

class ParserTest(unittest.TestCase):

  def test_parser(self):
    parser = Parser()
    state = parser.lex( "add(1,2)" )
    ast = parser.parse(state, "")

    assert(FunctionCall == ast[0].__class__)
    self.assertEquals("add", ast[0].name)
    self.assertEquals(2, len(ast[0].args))
    assert(Number == ast[0].args[0].__class__)
    assert(Number == ast[0].args[1].__class__)
 
  def assertCompile(self, source, testValue ):
    parser = Parser()
    ast = parser.parse(parser.lex( source ), "")
    gen = Generator().compile(ast)
    result = gen.execute()
    print gen.module
    self.assertEquals(result.as_real(Type.double()), testValue);
     
  def test_generator(self):
    self.assertCompile( "add(1,2)", 3 );
    self.assertCompile( "sub(5,1)", 4 );
    self.assertCompile( "sub(add(1,4),1)", 4 );
    self.assertCompile( "add(mul(4,4),1)", 17 );
    self.assertCompile( "div(mul(4,4),div(10,1))", 1.6 );
    self.assertCompile( "add({ add(1,1) }, 2)", 4 );


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

