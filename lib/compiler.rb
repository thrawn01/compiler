#!/usr/bin/env ruby -s

class SyntaxNode
  attr_reader :input, :interval

  def initialize(input, interval)
    @input = input
    @interval = interval
  end
end

class LexerState
  attr_accessor :input, :index, :syntax

  def initialize(input, index, syntax)
    @input = input
    @index = index
    @syntax = syntax
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
            return SyntaxNode.new(input, startIndex...state.index)
        end
        return false
    end

    def numeric( input, state )
        startIndex = state.index
        while isMatch?('\G[0-9]', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index)
        end
        return false
    end

    def symbol( input, state )
        startIndex = state.index
        while isMatch?('\G[A-Za-z]', state)
            state.index += 1
        end
        if startIndex != state.index
            return SyntaxNode.new(input, startIndex...state.index)
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

            if result = numeric( input, state )
                state.syntax << result
                next
            end

            if result = symbol( input, state )
                state.syntax << result
                next
            end
            
           break 
        end
        return state
    end

end


class Parser

end

