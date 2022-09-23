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
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner 
	# Constructor - Is passed a file to scan and outputs a token
	#               each time nextToken() is invoked.
	#   @c        - A one character lookahead 
		def initialize(filename)
			# Need to modify this code so that the program
			# doesn't abend if it can't open the file but rather
			# displays an informative message
			if (File.file?(filename))
				@f = File.open(filename,'r:utf-8')
			else
				puts "Tiny file does not exit"
				exit
			end
			
			# Go ahead and read in the first character in the source
			# code file (if there is one) so that you can begin
			# lexing the source code file 
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
				@f.close()
			end
		end
		
		# Method nextCh() returns the next character in the file
		def nextCh()
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
			end
			
			return @c
		end
	
		# Method nextToken() reads characters in the file and returns
		# the next token
		# You should also print what you find. Follow the format from the
		# example given in the instructions.
		def nextToken() 
			if @c == "eof"
				tok = Token.new(Token::EOF, "eof")
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
					
			elsif (whitespace?(@c))
				str =""
			
				while whitespace?(@c)
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::WS,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
			
			elsif (id?(@c))
				str =""
			
				while id?(@c)
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::ID,str)
				if (str.length > 1 && str == "print")
					tok = Token.new(Token::PRINT,str)
					puts "Next token is: #{tok.type} Next lexeme is: #{tok.type}" 
				elsif (str.length > 1)
					puts "Next token is: #{str} Next lexeme is: #{str}"
				else
					puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				end 
				return tok
			
			elsif (@c == '(')
				str =""
			
				while @c == '('
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::LPAREN,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
	
			elsif (equal?(@c))
				str =""
			
				while equal?(@c)
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::EQUALS,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
	
			elsif (int?(@c))
				str =""
			
				while int?(@c)
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::INT,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
			
			elsif (@c == ')')
				str =""
			
				while @c == ')'
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::RPAREN,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
			
			elsif (@c == '/')
				str =""
			
				while @c == '/'
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::DIVOP,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
	
			elsif (@c == '+')
				str =""
			
				while @c == '+'
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::ADDOP,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok

			elsif (@c == "-")
				str =""
			
				while @c == '-'
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::SUBOP,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
			
			elsif (@c == "*")
				str =""
			
				while @c == '*'
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::MULTOP,str)
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok

			else
				nextCh()
			
				tok = Token.new("unknown", "unknown")
				puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}" 
				return tok
			# elsif ...
			# more code needed here! complete the code here 
			# so that your lexer can correctly recognize,
			# display and return all tokens
			# in our grammar that we found in the source code file
			
			# FYI: You don't HAVE to just stick to if statements
			# any type of selection statement "could" work. We just need
			# to be able to programatically identify tokens that we 
			# encounter in our source code file.
			
			# don't want to give back nil token!
			# remember to include some case to handle
			# unknown or unrecognized tokens.
			# below I make the token that you should pass back
			# tok = Token.new("unknown","unknown")

			end
		
	end
	#
	# Helper methods for Scanner
	#
		def id?(lookAhead)
			lookAhead =~ /^[a-z]|[A-Z]$/
		end
	
		def int?(lookAhead)
			lookAhead =~ /^(\d)+$/
		end
	
		def whitespace?(lookAhead)
			lookAhead =~ /^(\s)+$/
		end
	
		def equal?(lookAhead)
			lookAhead =~ /^=$/
		end
	end
	
