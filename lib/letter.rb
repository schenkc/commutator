class Letter
  
  attr_accessor :index, :exp

  
  def initialize(letter_string)
    # return nil if letter_string.nil?

    temp_array = letter_string.split(/x_|\^/)
    @index = Integer(temp_array[1])
    temp_array[2].nil? ? @exp = 1 : @exp = temp_array[2].to_i

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
