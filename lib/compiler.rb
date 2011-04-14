#!/usr/bin/env ruby -s

require 'llvm'

class SyntaxNode
    attr_reader :input, :interval, :type

    def initialize(input, interval, type)
        @input = input
        @interval = interval
        @type = type
    end

    def value
        @input[@interval]
    end
end

class LexerState
    attr_accessor :input, :index, :syntax

    def initialize(input, index, syntax)
        @input = input
        @index = index
        @syntax = syntax
        @syntaxIndex = 0
    end

    def nextToken()
        token = @syntax[@syntaxIndex]
        @syntaxIndex += 1
        return token 
    end
end

class Function
    attr_accessor :name, :arguments

    def initialize(name, arguments)
        @name = name
        @arguments = arguments
    end
end

class Number
    attr_accessor :value

    def initialize(value)
        @value = value
    end
end

class String
    attr_accessor :value

    def initialize(value)
        @value = value
    end
end


class Lexer
    
    def isMatch?( regex, state )
        compiledRegex = Regexp.new(regex)
        # TODO: is there a more effecient way to do this?
        state.input.index(compiledRegex, state.index) == state.index
    end

    def whiteSpace( input, state )
        startIndex = state.index
        while isMatch?('\G[ \\t\\n\\r]', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index, :whitespace)
        end
        return false
    end

    def number( input, state )
        startIndex = state.index
        while isMatch?('\G[0-9]', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index, :number)
        end
        return false
    end

    def symbol( input, state )
        startIndex = state.index
        while isMatch?('\G[A-Za-z]', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index, :symbol)
        end
        return false
    end

    def token( input, state )
        startIndex = state.index
        if isMatch?('\G\W', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index, :token)
        end
        return false
    end

    def lex(input)
        state = LexerState.new(input, 0, [] )

        loop do

            # white space includes comments
            if result = whiteSpace( input, state )
                state.syntax << result
                next
            end

            if result = number( input, state )
                state.syntax << result
                next
            end

            if result = symbol( input, state )
                state.syntax << result
                next
            end
    
            # Match everything else
            if result = token( input, state )
                state.syntax << result
                next
            end
            
            if input.length == state.index 
               state.syntax << SyntaxNode.new(input, state.index...(state.index + 1), :token)
               break 
            end

        end
        return state
    end
    
end


class Parser
    
    def initialize()
        @symbolTable = { 'add'=>:function }
        @errors = []
    end
   
    def lex( input )
        Lexer.new().lex(input)
    end

    def parse( state, stopOn )
        ast = []

        while token = state.nextToken()
            if token.type == :symbol
                # Is the symbol in our symbol table
                symbol = @symbolTable[token.value]

                # Is it a function?
                if symbol == :function
                    ast << Function.new(token.value, parse(state, ')'))
                end

                # Is it a variable?
                if symbol == :variable
                    @errors << "variables un-implemented"
                end

                @errors << "Unknown symbol '%s'" % symbol
            end

            # Handle numbers, ( these are the only terminals )
            if token.type == :number
                ast << Number.new(token.value)
            end

            # Handle string literals 
            if token.type == :string
                ast << String.new(token.value)
            end

            # Stop parsing when we see this token
            if token.value == stopOn
                return ast
            end
        end

        return ast

    end

end


# Taken from orange 
# https://github.com/macournoyer/orange.git
class Generator
    include LLVM
    
    PCHAR = Type.pointer(Type::Int8Ty)
    INT   = Type::Int32Ty
    
    def initialize(mod = LLVM::Module.new("orange"), function=nil)
        @module   = mod
        @locals   = {}
      
        @function = function || @module.get_or_insert_function("main", Type.function(INT, [INT, Type.pointer(PCHAR)]))
        @entry_block = @function.create_block.builder
    end
    
    def preamble
        define_external_functions
    end
    
    def new_string(value)
        @entry_block.create_global_string_ptr(value)
    end
    
    def new_number(value)
        value.llvm
    end
    
    def call(func, *args)
      f = @module.get_function(func)
      @entry_block.call(f, *args)
    end
    
    def assign(name, value)
      ptr = @entry_block.alloca(value_type(value), 0)
      @entry_block.store(value, ptr)
      @locals[name] = ptr
    end
    
    def load(name)
      @entry_block.load(@locals[name])
    end
    
    def function(name)
      func = @module.get_or_insert_function(name, Type.function(INT, []))
      generator = Generator.new(@module, func)
      yield generator
      generator.finish
    end
    
    def finish
      @entry_block.return(0.llvm)
    end
    
    def optimize
      PassManager.new.run(@module)
    end
    
    def run
      ExecutionEngine.get(@module)
      ExecutionEngine.run_function(@function, 0.llvm, 0.llvm)
    end
    
    def to_file(file)
      @module.write_bitcode(file)
    end
    
    def inspect
      @module.inspect
    end
    
    private
      def define_external_functions
        @module.external_function("printf", Type.function(INT, [PCHAR], true))
        @module.external_function("puts", Type.function(INT, [PCHAR]))
        @module.external_function("read", Type.function(INT, [INT, PCHAR, INT]))
        @module.external_function("exit", Type.function(INT, [INT]))
      end
      
      TYPE_MAPPING = { 11 => PCHAR, 7 => INT }
      def value_type(value)
        TYPE_MAPPING[value.type.type_id]
      end
  end
end



end
