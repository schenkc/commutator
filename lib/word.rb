require "pry"

class Word
  attr_accessor :letters
  
  def initialize(collection = "")
    if collection.is_a? String
      @letters = []
      collection.split('.').each do |letter|
        @letters += Word.parse_letter_data(letter)
      end
    elsif collection.is_a? Array
      @letters = collection.map(&:dup)
    end
  end
  
  def self.parse_letter_data(str)
    regex = /x_(\d+)(\^(\-?\d*))?/
    letter_data = regex.match(str)
    
    if letter_data
      index = letter_data[1].to_i
      raise "Poorly formed expression, try again" if index < 0
      if letter_data[2].nil?
        exp = 1
      elsif letter_data[2] && letter_data[3] != ""
        exp = Integer(letter_data[3])
      elsif letter_data[2] && letter_data[3] == ""
        raise "Poorly formed expression, try again"
      end
    else
      raise "Poorly formed expression, try again"
    end
    
    result = []
    if exp >= -1 && exp <= 1
      result << Letter.new(index, exp)
    else
      exp.abs.times { result << Letter.new(index, exp/exp.abs) }
    end
    return result
  end
  
  def to_s
    return "" if letters.length < 1
    
    word_array = []
    
    current_index = letters.first.index
    current_exp = letters.first.exp
    
    letters[1..-1].each do |letter|
      if letter.index == current_index && letter.exp != 0 && letter.exp * current_exp > 0
        current_exp += letter.exp
      else
        if current_exp == 1
          word_array << "x_#{current_index}"
        else
          word_array << "x_#{current_index}^#{current_exp}"
        end
        
        current_index = letter.index
        current_exp = letter.exp
      end
    end
    
    if current_exp == 1
      word_array << "x_#{current_index}"
    else
      word_array << "x_#{current_index}^#{current_exp}"
    end
    
    word_array.join('.')
  end
  
  def to_latex
    return "" if letters.length < 1
    
    word_array = []
    
    current_index = letters.first.index
    current_exp = letters.first.exp
    
    letters[1..-1].each do |letter|
      if letter.index == current_index
        current_exp += letter.exp
      else
        if current_exp == 1
          word_array << "x_{#{current_index}}"
        else
          word_array << "x_{#{current_index}}^{#{current_exp}}"
        end
        
        current_index = letter.index
        current_exp = letter.exp
      end
    end
    
    if current_exp == 1
      word_array << "x_{#{current_index}}"
    else
      word_array << "x_{#{current_index}}^{#{current_exp}}"
    end
    
    word_array.join('.')
  end
  
  def [](index)
    letters[index]
  end
  
  def []=(idx, letter)
    # this takes a letter object, not a letter string
    # should check to make sure that letter is a letter object
    letters[idx] = letter
  end
  
  def each(&block)
    i = 0
    while i < letters.length
      block.call(self[i])
      i += 1
    end
    
    self
  end
  
  def dup
    Word.new(self.letters)
  end
  
  def <<(letter)
    raise "Can only append a letter object" unless letter.class == Letter
    @letters << letter
    
    self
  end
  
  def *(other)
    if other.class == Word
      Word.new(@letters + other.letters)
    elsif other.class == Letter
      self << other
    else
      raise "What?"
    end
  end
  
  def number_of_letters
    letters.inject(0) { |accum, letter| accum += letter.exp.abs }
  end

  def different_representation?(word)
    return false if self == word
    self.to_normal_form == word.to_normal_form
  end
  
  def ==(compare)
    self.to_s == compare.to_s
  end
  
  def nil?
    self.letters.empty?
  end
  
  def invert!
    letters.map! { |letter| letter.invert! }.reverse!
    
    self
  end
  
  def invert
    word = self.dup
    word.invert!
  end
  
  def delete_letter!(i)
    letters.delete_at(i)
  end
  
  def combine_like_terms!
    i = 0
    until self[i+1].nil?
      if self[i].exp == 0
        delete_letter!(i)
      elsif self[i].inverse?(self[i+1])
        delete_letter!(i+1)
        delete_letter!(i)
        i = 0
      else
        i += 1
      end
    end
    self
  end
  
  def combine_like_terms
    self.dup.combine_like_terms!
  end
  
  def swap!(i,j)
    return self if i > letters.length || j > letters.length
    letters[i], letters[j] = letters[j], letters[i]
    self
  end
  
  def move_right(i, side = :right)
    return self if letters.length == 1 && i == 0
    raise "No letter to move." unless i < letters.length
    
    left = letters[i]
    right = letters[i+1]
    
    if left.pos? && right.pos?
      pos_pos_swap(i, side)

    elsif left.neg? && right.pos?
      neg_pos_swap(i, side)
      
    elsif left.neg? && right.neg?
      neg_neg_swap(i, side)
      
    elsif left.pos? && right.neg?
      pos_neg_swap(i, side)
    end

  end
  
  def pos_pos_swap(i, side)
    left = letters[i]
    right = letters[i+1]
    
    if left.index == right.index
      return self
    elsif right.index - left.index > 1
      right.lower_index!
      self.swap!(i, i+1)
    elsif right.index - left.index == 1
        right_index = right.index
        left_index = left.index
        
      if side == :right
        sub_word = [Letter.new(right_index, 1), Letter.new(left_index, 1), 
                    Letter.new(left_index, -1), Letter.new(right_index, -1), 
                    Letter.new(left_index, 1), Letter.new(right_index, 1)]
      elsif side == :left
        sub_word = [Letter.new(left_index, 1), Letter.new(right_index, 1),
                    Letter.new(left_index, -1), Letter.new(right_index, -1),
                    Letter.new(right_index, 1), Letter.new(left_index, 1)]
      end
      letters[i,2] = sub_word
      self
    else
      left.raise_index!
      self.swap!(i, i+1)
    end
  end
  
  def neg_pos_swap(i, side)
    left = letters[i]
    left_index = left.index
    right = letters[i+1]
    right_index = right.index
    
    if left_index == right_index
      self.swap!(i, i+1)
    elsif right_index < left_index
      left.raise_index!
      self.swap!(i, i+1)
    elsif left_index < right_index
      right.raise_index!
      self.swap!(i, i+1)
    end
  end
  
  def neg_neg_swap(i, side)
    left = letters[i]
    left_index = left.index
    right = letters[i+1]
    right_index = right.index
    
    if left_index == right_index
      return self
    elsif left_index < right_index # wrong order
      right.raise_index!
      self.swap!(i, i+1)
    elsif left_index - right_index > 1 # right order bigger that 1 apart
      left.lower_index!
      self.swap!(i, i+1)
    elsif left_index - right_index == 1 # right order, differnt exactly 1
      
      if side == :right
        sub_word = [Letter.new(left_index, -1), Letter.new(right_index, -1),
                    Letter.new(left_index, 1), Letter.new(right_index, 1),
                    Letter.new(right_index, -1), Letter.new(left_index, -1)]
      elsif side == :left
        sub_word = [Letter.new(right_index, -1), Letter.new(left_index, -1),
                    Letter.new(left_index, 1), Letter.new(right_index, 1),
                    Letter.new(left_index, -1), Letter.new(right_index, -1)]
      end
      letters[i,2] = sub_word
      self
    end
  end
  
  def pos_neg_swap(i, side)
    left = letters[i]
    left_index = left.index
    right = letters[i+1]
    right_index = right.index
    
    if left_index == right_index
      self.swap!(i, i+1)
    elsif left_index - right_index > 1
      left.lower_index!
      self.swap!(i, i+1)
    elsif right_index - left_index > 1
      right.lower_index!
      self.swap!(i, i+1)
    elsif right_index - left_index == 1
      if side == :right
        sub_word = [Letter.new(right_index, -1), Letter.new(left_index, 1),
                    Letter.new(left_index, -1), Letter.new(right_index, 1),
                    Letter.new(left_index, 1), Letter.new(right_index, -1)]
      elsif side == :left
        sub_word = [Letter.new(left_index, 1), Letter.new(right_index, -1),
                    Letter.new(left_index, -1), Letter.new(right_index, 1),
                    Letter.new(right_index, -1), Letter.new(left_index, 1)] 
      end
      letters[i,2] = sub_word
      self
    elsif left_index - right_index == 1
      if side == :right
        sub_word = [Letter.new(right_index, -1), Letter.new(left_index, 1),
                    Letter.new(left_index, -1), Letter.new(right_index, 1),
                    Letter.new(left_index, 1), Letter.new(right_index, -1)] 
      elsif side == :left
        sub_word = [Letter.new(left_index, 1), Letter.new(right_index, -1),
                    Letter.new(left_index, -1), Letter.new(right_index, 1),
                    Letter.new(right_index, -1), Letter.new(left_index, 1)]
      end
      letters[i,2] = sub_word
      self
    end
  end
  
  def should_move_right?(i)
    left, right = self[i], self[i+1]
    
    if left.pos? && right.pos?
      return right.index < left.index
    elsif left.neg? && right.neg?
      return left.index < right.index
    else
      return left.neg? && right.pos?
    end
  end
  
  def to_normal_form!
    swapped = true
    while swapped
      swapped = false
      (0...self.number_of_letters - 1).each do |i|
        if self.should_move_right?(i)
          self.move_right(i)
          swapped = true
        end
      end
    end
    combine_like_terms!
    
    # I think this conjugate down
    left = 0
    right = self.letters.length - 1
    until left == right
      if self[left].inverse?(self[right])
        index = self[left].index
        if self[left + 1].index - index > 1 && self[right - 1].index - index > 1
          ((left + 1)..(right - 1)).each do |j|
            self[j].lower_index!
          end
          self.delete_at(right)
          self.delete_at(left)
          left = 0
          right = self.letters.length - 1
        elsif self[left].index == self[left + 1].index
          left += 1
        elsif self[right].index == self[right - 1].index
          right -= 1
        else
          left += 1
          right -= 1
        end
      end
      
      if self[left].index > self[right].index
        right -= 1
      elsif self[left].index < self[right].index
        left += 1
      elsif self[left].index == self[right].index
        left = right if self[left].exp == self[right].exp
      end
    end
    self

    # end
    # #lower index of everything when first and last letters are of the same index
    #     i = 0
    # until self[i+1].nil?
    #   j = i
    #   #puts self
    #   #puts "i is #{i} and self[i].index is #{self[i].index}"
    #   until self[j+1].nil?
    #     j = j+1
    #     #puts "j is #{j} and self[j].index is #{self[j].index}"
    #     if ((self[i].index == self[j].index) && ((self[i+1].index-1)  != self[i].index) && ((self[j-1].index-1) != self[j].index))
    #       #puts "we are in here!"
    #       #puts i
    #       #puts j
    #       (i+1..j-1).each do |q|
    #         self[q].lower_index!
    #         #puts self
    #       end
    #       if self[j].exp == -1
    #           delete_letter!(j)
    #         else
    #           self[j].add_exp(1)
    #         end
    #         if self[i].exp == 1
    #           delete_letter!(i)
    #         else
    #           self[i].add_exp(-1)
    #       end
    #       i=0
    #       j=i
    #       #j = j+1
    #     else
    #       #j = j+1
    #     end
    #   end
    #   i = i+1
    # end
    self
  end
  
  def to_normal_form
    self.dup.to_normal_form!
  end
  
  def in_commF?
    z, j = 0, 0
    
    self.each { |letter| letter.index == 0 ? z += letter.exp : j += letter.exp }
        
    z == 0 && j == 0
  end
  
  def word_length
    self.to_normal_form!
    temp_word = ""
    i = 0
    until self[i].nil?
      if self[i].exp > 0
        if self[i].index == 0
          self[i].exp.times { temp_word = temp_word + ".x_0" }
        elsif self[i].index == 1
          self[i].exp.times { temp_word = temp_word + '.x_1' } 
        else
         (self[i].index - 1).times { temp_word = temp_word + '.x_0^-1'}
         (self[i].exp).times { temp_word = temp_word + '.x_1' }
         (self[i].index - 1).times { temp_word = temp_word + '.x_0' }
        end
      elsif self[i].exp < 0
        if self[i].index == 0
          self[i].exp.abs.times { temp_word = temp_word + "." + "x_0^-1" }
        elsif self[i].index == 1
          self[i].exp.abs.times { temp_word = temp_word + '.' +'x_1^-1' } 
        else
         (self[i].index - 1).times { temp_word = temp_word + '.' + 'x_0^-1'}
         (self[i].exp.abs).times { temp_word = temp_word + '.' + 'x_1^-1' }
         (self[i].index - 1).times { temp_word = temp_word + '.' + 'x_0' }
        end  
      end
      i += 1
    end
    temp_word[0] = ''
    working_word = Word.new(temp_word)
    working_word = working_word.remove_inverses!
    if working_word.nil?
      return 0
    else
      return working_word.size
    end
  end

  def to_two_generators
    not_self = self.to_normal_form
    temp_word = ""
    i = 0
    until not_self[i].nil?
      if not_self[i].exp > 0
        if not_self[i].index == 0
          not_self[i].exp.times { temp_word = temp_word + ".x_0" }
        elsif not_self[i].index == 1
          not_self[i].exp.times { temp_word = temp_word + '.x_1' }
        else
         (not_self[i].index - 1).times { temp_word = temp_word + '.x_0^-1'}
         (not_self[i].exp).times { temp_word = temp_word + '.x_1' }
         (not_self[i].index - 1).times { temp_word = temp_word + '.x_0' }
        end
      elsif not_self[i].exp < 0
        if not_self[i].index == 0
          not_self[i].exp.abs.times { temp_word = temp_word + "." + "x_0^-1" }
        elsif not_self[i].index == 1
          not_self[i].exp.abs.times { temp_word = temp_word + '.' +'x_1^-1' }
        else
         (not_self[i].index - 1).times { temp_word = temp_word + '.' + 'x_0^-1'}
         (not_self[i].exp.abs).times { temp_word = temp_word + '.' + 'x_1^-1' }
         (not_self[i].index - 1).times { temp_word = temp_word + '.' + 'x_0' }
        end
      end
      i += 1
    end
    temp_word[0] = ''
    working_word = Word.new(temp_word)
    working_word = working_word.remove_inverses!
    #if working_word.nil?
    #  return 0
    #else
      return working_word
    #end
  end

  
  def pos_word
    working_word = self.to_normal_form
    indexing_word = self.to_normal_form
    i = 0
    indexing_word.each do |letter|
      if letter.nil?
        puts "Empty"
        return working_word
      elsif letter.exp > 0
        i = i + 1
      elsif letter.exp < 0
        working_word.delete_letter!(i)
      end
    end
    return working_word
  end
  
  def neg_word
    working_word = self.to_normal_form.invert
    indexing_word = self.to_normal_form.invert
    i = 0
    indexing_word.each do |letter|
      if letter.nil?
        puts "Empty"
        return working_word
      elsif letter.exp > 0
        i = i + 1
      elsif letter.exp < 0
        working_word.delete_letter!(i)
      end
    end
    return working_word.invert!
  end

  def min_conj_class!
    self.to_normal_form!
    changed = true
    until changed == false do
      changed = false
      if self.nil? || self[0]==self[-1]
      elsif self[0].index == self[-1].index
        changed = true
        if self[-1].exp == -1
          delete_letter!(-1)
        else         
          self[-1].add_exp(1)
        end
        if self[0].exp == 1
          delete_letter!(0)
        else
          self[0].add_exp(-1)
        end
      end
    end
    return self
  end

  def min_conj_class
    if self.nil?
      return nil
    else
      t = Word.new(self.to_s).min_conj_class!
      return t
    end
  end

  def number_carots
    temp_word = self
    if self.nil?
      return 0
    else
      domain = temp_word.pos_word 
      range =temp_word.neg_word.invert! 
      domain_number = 1 
      range_number = 1
      domain.each do |letter|
        a = letter.index.to_i
        if letter.exp.nil?
          b = 1
        else
          b = letter.exp.to_i 
        end

        if domain_number > a #add a carot not on the right spine 
          domain_number = domain_number + b 
        elsif domain_number < a #add a carot on the right spine, by adding to the spine 
          domain_number = 1 +a +b 
        elsif domain_number = a #add a carot to the 2nd to last leave.  
          domain_number = domain_number + 1 + b
        end
      end
      range.each do |letter|
        c = letter.index.to_i
        if letter.exp.nil?
          d = 1
        else
          d = letter.exp.to_i
        end

        if range_number > c
          range_number = range_number + d
        elsif range_number < c 
          range_number = 1 + c + d
        elsif range_number = c
          range_number = range_number + 1 + d
        end
      end
      return [domain_number, range_number].max
    end
  end
end

def multiply(a,b)
  if a.nil? && b.nil?
    Word.new(nil)
  elsif a.nil?
    Word.new(b.to_s)
  elsif b.nil?
    Word.new(a.to_s)
  else
    Word.new(a.to_s+'.'+b.to_s)
  end
end 
  
def conjugate(a,b)
  multiply(multiply(b.invert, a), b)
end
  
def commutate(b,a)
  multiply(conjugate(a.invert,b), a)
end
