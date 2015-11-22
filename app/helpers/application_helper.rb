module ApplicationHelper
  
	
    def detel(code)
      c = code.bytes.to_a
  		new = []
  		c.each_with_index do |element,index|
  			new[index] = element - 20 - 2 *index
  		end
  		return new.pack('c*')
    end
    
    
end
