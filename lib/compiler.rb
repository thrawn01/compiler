#!/usr/bin/env ruby -s

class Compiler
     @value = ""

    def getToken(code)
        code = StringIO.new(code)
        
        while isSpace( char )
            char = getChar(code)
        end
            
        if isAlpha( char )
            while isAplhaNum(char = getChar())
                @value += char
            end

            if @value == "define"
                return :define
            end
            if @value == "extern"
                return :extern
            return :symbol
        end
                      
        if isDigit( char )
            @value += char
            while isDigit( char = getChar() )
                @value += char
            end
            return :digit
        end

    end
end


