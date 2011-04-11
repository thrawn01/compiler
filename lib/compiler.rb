#!/usr/bin/env ruby -s

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

