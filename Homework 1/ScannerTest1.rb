# Test the Token class
tok = Token.new("atype","atext") 
puts "Token type: #{tok.type}" 
puts "Token text: #{tok.text}" 

tok.type = "btype"
tok.text = "btext"

puts "Token type: #{tok.type}" 
puts "Token  text:  #{tok.text}"  
puts  "Token: #{tok}"

end
