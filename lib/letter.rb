class Letter
  
  attr_accessor :index, :exp

  
  def initialize(index, exp = 1)
    # regex = /x_(\d+)(\^(\-?\d*))?/
    # letter_data = regex.match(letter_string)
    
    @index = index
    raise "Bad index, try again" if @index < 0
    @exp = exp
    raise "Bad exponent, try again" if @exp < -1 || @exp > 1
    # if letter_data
    #   @index = letter_data[1].to_i
    #   raise "Bad index, try again" if @index < 0
    #   if letter_data[2].nil?
    #     @exp = 1
    #   elsif letter_data[2] && letter_data[3] != ""
    #     @exp = Integer(letter_data[3])
    #   elsif letter_data[2] && letter_data[3] == ""
    #     raise "Bad exponent, try again"
    #   end
    # else
    #   raise "Bad index, try again"
    # end
  end
  
  def to_s
    if @exp == 1
      "x_#{@index}"
    else
      "x_#{@index}\^#{@exp}"
    end
  end
  
  def to_latex
    if @exp == 1
      "x_\{#@index\}"
    else 
      "x_\{#@index\}\^\{#@exp\}"
    end
  end
  
  def lower_index!
    raise "Can't have negative index" if @index == 0
    @index -= 1
    self
  end
  
  def raise_index!
    @index += 1
    self
  end
 
  # def add_exp(input)
  #   @exp += input
  # end
  
  def invert!
    @exp = -@exp
    self
  end
  
  def invert
    self.dup.invert!
  end 
  
  def ==(letter)
    return false if letter.nil? || letter.class != Letter
    return (index == letter.index && exp == letter.exp) unless letter.nil?
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
