class Letter
  
  attr_accessor :index, :exp

  
  def initialize(letter_string)
    regex = /x_(\d+)(\^(\-?\d*))?/
    letter_data = regex.match(letter_string)
    
    if letter_data
      @index = letter_data[1].to_i
      raise "Bad index, try again" if @index < 0
      if letter_data[2].nil?
        @exp = 1
      elsif letter_data[2] && letter_data[3] != ""
        @exp = Integer(letter_data[3])
      elsif letter_data[2] && letter_data[3] == ""
        raise "Bad exponent, try again"
      end
    else
      raise "Bad index, try again"
    end


  end
  
  def to_s
    if @exp == 1
      "x_#{@index}"
    elsif @exp == 0
      ""
    else
      "x_#{@index}\^#{@exp}"
    end
  end
  
  def to_latex
    if @exp == 1
      "x_\{#@index\}"
    elsif @exp == 0
      ""
    else 
      "x_\{#@index\}\^\{#@exp\}"
    end
  end
  
  def lower_index!
    raise "Can't have negitive index" if @index == 0
    @index -= 1
    self
  end
  
  def raise_index!
    @index += 1
    self
  end
 
 #  is this needed?  I think not, but I don't know if I call it anywere
  def add_exp(input)
    exp = exp + input.to_i
  end
  
  def invert!
    @exp = -@exp
    self
  end
  
  def invert
    Letter.new(self.to_s).invert!
  end 
  
  def ==(letter)
    return (index == letter.index && exp == letter.exp) unless letter.nil?
    return false if letter.nil?
  end
  
  def inverse?(letter)
    return (index == letter.index && exp == -letter.exp) unless letter.nil?
    return false if letter.nil?
  end 
  
  def neg?
    exp < 0
  end
  
  def pos?
    exp > 0
  end
  
end
