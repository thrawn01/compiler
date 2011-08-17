#!/usr/bin/python

import re
from llvm import *
from llvm.core import *
from llvm.ee import ExecutionEngine, TargetData

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


class FunctionCall():

  def __init__(self, name, args, func):
    self.name = name
    self.args = args
    self.func = func
    
  def compile(self, builder):
    return self.func(builder,self.args)
        

class Number():

  def __init__(self, value):
    self.value = value
 
  def compile(self, builder):
    return Constant.real( Type.double(), int(self.value)) 


class Block():

  def __init__(self, body):
    self.body = body
    
  def compile(self, builder):
    return self.body[0].compile(builder)


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
    self.symbolTable = { 'add': { 'function': lambda builder, args: builder.fadd(args[0].compile(builder), args[1].compile(builder)) },
                         'sub': { 'function': lambda builder, args: builder.fsub(args[0].compile(builder), args[1].compile(builder)) },
                         'mul': { 'function': lambda builder, args: builder.fmul(args[0].compile(builder), args[1].compile(builder)) },
                         'div': { 'function': lambda builder, args: builder.fdiv(args[0].compile(builder), args[1].compile(builder)) } }
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
        if 'function' in symbol:
          ast.append(FunctionCall(token.value(), self.parse(state, ')'), symbol['function']))

        # Is it a variable?
        if symbol == 'variable':
          self.errors.append("variables un-implemented")

        self.errors.append( "Unknown symbol '%s'" % symbol )

      # Handle numbers
      if token.type == 'number':
        ast.append(Number(token.value()))
      
      if token.value() == '{':
        ast.append(Block(self.parse(state, '}')))

      # Stop parsing when we see this token
      if token.value() == stopOn:
        return ast

      token = state.nextToken()

    return ast

class Generator():

  def __init__(self):
    self.module = Module.new('generator')
    # Create a main function with no arguments and add it to the module
    self.main = self.module.add_function(Type.function(Type.double(), []), "main")
    # Create a new builder with a single basic block
    self.builder = Builder.new(self.main.append_basic_block("entry"))
    # Create an executor engine for JIT and Interpreter execution
    self.executor = ExecutionEngine.new(self.module)
 
  def compile(self, ast):
   ret = ast[0].compile(self.builder)
   self.builder.ret(ret)
   return self
   
  def execute(self):
   return self.executor.run_function(self.main, [])

