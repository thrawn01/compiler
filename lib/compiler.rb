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
    attr_accessor :symbol, :arguments

    def initialize(symbol, arguments)
        @symbol = symbol
        @arguments = arguments
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

    def parse(input)
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
        @symbolTable = [ 'add' ]
    end
    
    def parseExpression( state )
        while token = state.nextToken()
            
        end
    end

    def parse( lexer, input, stopOn )
        state = lexer.parse( input )
        ast = []

        while token = state.nextToken()
            # Look for a pre-defined symbol
            if token.type == :symbol
                symbol = lookupSymbol(token)
                if symbol == :function
                    ast << Function.new(symbol, parseExpression(state))
                end
                errors << "Unknown symbol '%s'" % symbol
            end
            if token.type == :number
                ast << Number.new(token.value)
            end

            # Find our token to stop parsing on
            if token.value == stopOn
                return ast
            end
        end

    end

    def lookupSymbol( token )
        @symbolTable[token.value]
    end
end

