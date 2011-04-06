#!/usr/bin/env ruby -s

class SyntaxNode
  attr_reader :input, :interval
  attr_accessor :parent

  def initialize(input, interval)
    @input = input
    @interval = interval
  end
end

class Parser
    
    def initialize
        @index = 0
    end

    def isMatch?( regex, input, index )
        compiledRegex = Regexp.new(regex)

        input.index(compiledRegex, index) == index
    end

    def whiteSpace( input, index )
        startIndex, result = index, ''
        while isMatch?('\G[ \\t\\n\\r]', input, index)
            index += 1
        end
        SyntaxNode.new(input, startIndex...index)
    end

    def parse(input)
        
        # Parse Terminals first ( Including comments )
        if result = whiteSpace( input, @index )
            return result
        end

        #if result = numeric( input, index )
            #return result
        
        # Parse symbols
        #if result = symbol( input, index )
            #return result
        
        # Parse Function defs
        #if result = functionDef( input, index )
        #    return result
       
   end
end


