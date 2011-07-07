#!/usr/bin/python

import re

class SyntaxNode():

  def __init__(self, input, range, type):
    self.input = input
    self.range = range
    self.type = type

  def value(self):
    return self.input[self.range[0]:self.range[1]]


class LexerState():

  def __init__(self, input, index, syntax):
    self.input = input
    self.index = index
    self.syntax = syntax
    self.syntaxIndex = 0

  def nextToken(self):
    token = self.syntax[self.syntaxIndex]
    self.syntaxIndex += 1
    return token 


class Function():

  def __init__(self, name, arguments):
    self.name = name
    self.arguments = arguments


class Number():

  def __init__(self, value):
    self.value = value


class String():

  def initialize(self, value):
    self.value = value

class Lexer():
    
  def isMatch(self, regex, state):
    try:
      if re.match(regex, state.input[state.index]):
        return True
      return False
    except IndexError,e:
      return False

  def whiteSpace(self, input, state):
    startIndex = state.index
    while self.isMatch('[ \\t\\n\\r]', state):
      state.index += 1

    if startIndex != state.index:
      return SyntaxNode(input, (startIndex,state.index), 'whitespace')
    return False

  def number(self, input, state):
    startIndex = state.index
    while self.isMatch('[0-9]', state):
      state.index += 1
    
    if startIndex != state.index:
      return SyntaxNode(input, (startIndex,state.index), 'number')
    return False

  def symbol(self, input, state ):
      startIndex = state.index
      while self.isMatch('[A-Za-z]', state):
        state.index += 1
      
      if startIndex != state.index:
        return SyntaxNode(input, (startIndex,state.index), 'symbol')
      return False

  def token(self, input, state ):
      startIndex = state.index
      if self.isMatch('\W', state):
          state.index += 1
      if startIndex != state.index:
          return SyntaxNode(input, (startIndex,state.index), 'token')
      return False


  def lex(self, input):
      state = LexerState(input, 0, [] )

      while 1:
        # If we reach the end of the input
        if len(input) == state.index:
          # Consider EOF a token
          state.syntax.append( SyntaxNode(input, (state.index,state.index + 1), 'token') )
          break 

        # white space includes comments
        result = self.whiteSpace( input, state )
        if result:
          state.syntax.append(result)
          continue

        result = self.number( input, state )
        if result:
          state.syntax.append(result)
          continue

        result = self.symbol( input, state )
        if result:
          state.syntax.append(result)
          continue

        # Match everything else
        result = self.token( input, state )
        if result:
          state.syntax.append(result)
      
      return state


class Parser():
  
  def __init__(self):
    self.symbolTable = { 'add':'function' }
    self.errors = []
 
  def lex(self, input):
    return Lexer().lex(input)

  def parse(self, state, stopOn):
    ast = []

    token = state.nextToken()
    while token:
      if token.type == 'symbol':
        # Is the symbol in our symbol table
        symbol = self.symbolTable[token.value()]

        # Is it a function?
        if symbol == 'function':
          ast.append(Function(token.value(), self.parse(state, ')')))

        # Is it a variable?
        if symbol == 'variable':
          self.errors.append("variables un-implemented")

        self.errors.append( "Unknown symbol '%s'" % symbol )

      # Handle numbers, ( these are the only terminals )
      if token.type == 'number':
        ast.append(Number(token.value()))

      # Handle string literals 
      if token.type == 'string':
        ast.append(String(token.value()))

      # Stop parsing when we see this token
      if token.value() == stopOn:
        return ast

      token = state.nextToken()

    return ast

