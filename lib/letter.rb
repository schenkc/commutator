class Letter
  
  attr_accessor :index, :exp

  
  def initialize(index, exp = 1)
    
    @index = index
    raise "Bad index, try again" if @index < 0
    
    @exp = exp
    raise "Bad exponent, try again" if @exp < -1 || @exp > 1
    
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
  
  def dup
    Letter.new(@index, @exp)
  end
  
  def invert!
    @exp = -@exp
    self
  end
  
  def invert
    self.dup.invert!
  end 
  
  def ==(letter)
    return false if (letter.nil? || letter.class != Letter)
    return (index == letter.index && exp == letter.exp)
  end
  
  def inverse?(letter)
    return false if letter.nil?
    return (index == letter.index && exp == -letter.exp)
  end 
  
  def neg?
    exp < 0
  end
  
  def pos?
    exp > 0
  end
end
