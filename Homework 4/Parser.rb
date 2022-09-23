# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# EPSILON    -->   ""
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Lexer.rb"
class Parser < Scanner

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        tok1 = term()
        tok2, tok3 = etail()

        if tok3 != nil
            tok3.addChild(tok1)
        end
        if tok2 == nil && tok3 == nil
            return tok1
        end
        if tok2 == nil && tok3 != nil
            return tok3
        end

        return tok2
    end

    def term()
        tok1 = factor()
        tok2, tok3 = ttail()

        if tok3 != nil
            tok3.addChild(tok1)
        end
        if tok2 == nil && tok3 == nil
            return tok1
        end
        if tok2 == nil && tok3 != nil
            return tok3
        end

        return tok2
    end

    def factor()
        fct = AST.new(Token.new("factor", "factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            fct = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return fct
    end

    def ttail()
        ttail = AST.new(@lookahead)
        if (@lookahead.type == Token::MULTOP)
            match(Token::MULTOP)
            tok1 = factor()
            ttail.addChild(tok1)
            tok2, tok3 = ttail()
            if tok3 != nil
                tok3.addChild(ttail)
            end
            return tok2, ttail
        elsif (@lookahead.type == Token::DIVOP)
            match(Token::DIVOP)
            tok1 = factor()
            ttail.addChild(tok1)
            tok2, tok3 = ttail()
            if tok3 != nil
                tok3.addChild(ttail)
            end
            return tok2, ttail
		else
			return nil
        end
        return ttail
    end

    def etail()
        etail = AST.new(@lookahead)
        if (@lookahead.type == Token::ADDOP)
            match(Token::ADDOP)
            tok1 = term()
            etail.addChild(tok1)
            tok2, tok3 = etail()
            if tok3 != nil
                tok3.addChild(etail)
            end
            return tok2, etail
        elsif (@lookahead.type == Token::SUBOP)
            match(Token::SUBOP)
            tok1 = term()
            ttail.addChild(tok1)
            tok2, tok3 = etail()
            if tok3 != nil
                tok3.addChild(etail)
            end
            return tok2, etail
		else
			return nil
        end
        return etail
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end