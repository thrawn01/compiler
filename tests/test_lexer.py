#!/usr/bin/python

import unittest, logging, sys
from ollie import Lexer,Parser,Function,Number,Generator

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
log = logging.getLogger( "test" )

class LexerTest(unittest.TestCase):

  def test_parseWhiteSpace(self):
    state = Lexer().lex("    add")
    self.assertEqual("    add", state.syntax[0].input )
    self.assertEquals((0,4), state.syntax[0].range )
    self.assertEquals('whitespace', state.syntax[0].type )
    self.assertEquals("    ", state.syntax[0].value() )
  

  def test_parseWhiteSpace(self):
    state = Lexer().lex("    add")
    self.assertEquals("    add", state.syntax[0].input )
    self.assertEquals((0,4), state.syntax[0].range )
    self.assertEquals('whitespace', state.syntax[0].type )
    self.assertEquals("    ", state.syntax[0].value() )

  def test_parseSymbol(self):
    state = Lexer().lex("    add")
    self.assertEquals("    add", state.syntax[0].input )
    self.assertEquals((0,4), state.syntax[0].range )
    self.assertEquals((4,7), state.syntax[1].range )
    self.assertEquals('symbol', state.syntax[1].type )
    self.assertEquals('add', state.syntax[1].value() )
    self.assertEquals('', state.syntax[2].value() )

  def test_parseNumeric(self):
    lexer = Lexer()
    state = lexer.lex("   1   ")
    self.assertEquals((0,3), state.syntax[0].range )
    self.assertEquals((3,4), state.syntax[1].range )
    self.assertEquals('number', state.syntax[1].type )
    self.assertEquals('1', state.syntax[1].value() )
    self.assertEquals((4,7), state.syntax[2].range )

  def test_parseTokens(self):
    state = Lexer().lex("    add(1,2)\n")
    self.assertEquals("    add(1,2)\n", state.syntax[0].input )
    self.assertEquals((0,4), state.syntax[0].range )
    self.assertEquals((4,7), state.syntax[1].range )
    self.assertEquals((7,8), state.syntax[2].range )
    self.assertEquals((8,9), state.syntax[3].range )
    self.assertEquals((9,10), state.syntax[4].range )
    self.assertEquals((10,11), state.syntax[5].range )
    self.assertEquals((11,12), state.syntax[6].range )
    self.assertEquals((12,13), state.syntax[7].range )
    self.assertEquals('\n', state.syntax[7].value() )


