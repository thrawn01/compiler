#!/usr/bin/env ruby -s

class SyntaxNode
    attr_reader :input, :interval, :type

    def initialize(input, interval, type)
        @input = input
        @interval = interval
        @type = type
    end
end

class LexerState
    attr_accessor :input, :index, :syntax

    def initialize(input, index, syntax)
        @input = input
        @index = index
        @syntax = syntax
    end

    def nextToken()
        for token in @syntax
            yield token
        end
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
        while isMatch?('\G\W', state)
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
               break 
            end

        end
        return state
    end
    
end


class Parser
    
    def parse( lexer, input )
        state = lexer.parse( input )
        ast = []

        state.tokens { |token|
            if token.type == :symbol
                symbol = lookupSymbol(token.value)
            end
            if symbol == :function
                arguments = parseArguments()
                ast << Function.new(arguments)
            end
        }

    end
end

