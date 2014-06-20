require "debugger"

class Word
  attr_accessor :letters
  
  def initialize(word)
    @letters = []
    word.split('.').each do |letter|
      @letters << Letter.new(letter)
    end
  end
  
  def to_s
    word_array = []
    
    letters.each do |letter|
      word_array << letter.to_s
    end
    
    word_array.join('.')
  end
  
  def to_latex
    word_array = []
    
    letters.each do |letter|
      word_array << letter.to_latex
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
    Word.new(self.to_s)
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
    i=0
    until self[i+1].nil?
      if self[i].index == self[i+1].index
        self[i].exp += self[i+1].exp
        delete_letter!(i+1)
        delete_letter!(i) if self[i].exp == 0
        i = 0
      else
        i +=1
      end
    end
    self
  end
  
  def combine_like_terms
    self.dup.combine_like_terms!
  end
  
  def swap!(i,j)
    letters[i], letters[j] = letters[j], letters[i]
    self
  end
  
  def to_normal_form!
    i = 0
    until self[i+1].nil?
      if self[i].neg? && self[i+1].pos?
        if self[i].index < self[i+1].index
          self[i].exp.abs.times {self[i+1].raise_index!}
          swap!(i, i+1)
          i=-1
#          puts self
        elsif self[i].index > self[i+1].index
          self[i+1].exp.abs.times {self[i].raise_index!}
          swap!(i,i+1)
          i=-1
#          puts self
        elsif self[i].index == self[i+1].index
          self[i].add_exp(self[i+1].exp)
          delete_letter!(i+1)
          if self[i].exp == 0
            delete_letter!(i)
          end
          i=-1
#          puts self
        end
      elsif self[i].pos? && self[i+1].pos?
        if self[i].index > self[i+1].index
          self[i+1].exp.abs.times {self[i].raise_index!}
          swap!(i,i+1)
          i=-1
#          puts self
        elsif self[i].index == self[i+1].index
          self[i].add_exp(self[i+1].exp)
          delete_letter!(i+1)
#          puts self
          i=-1
        end
      elsif self[i].neg? && self[i+1].neg?
        if self[i].index < self[i+1].index
          self[i].exp.abs.times {self[i+1].raise_index!}
          swap!(i,i+1)
#          puts self
          i=-1
        elsif self[i].index == self[i+1].index
          self[i].add_exp(self[i+1].exp)
          delete_letter!(i+1)
#          puts self
          i=-1
        end
      elsif self[i].pos? && self[i+1].neg?
        if self[i].index == self[i+1].index
          self[i].add_exp(self[i+1].exp)
          delete_letter!(i+1)
          if self[i].exp == 0
            delete_letter!(i)
          end
#          puts self
          i=-1
        end
      end 
      i+=1      
    end
    #lower index of everything when first and last letters are of the same index
        i = 0
    until self[i+1].nil?
      j = i
      #puts self      
      #puts "i is #{i} and self[i].index is #{self[i].index}"
      until self[j+1].nil?
        j = j+1
        #puts "j is #{j} and self[j].index is #{self[j].index}"
        if ((self[i].index == self[j].index) && ((self[i+1].index-1)  != self[i].index) && ((self[j-1].index-1) != self[j].index))
          #puts "we are in here!"
          #puts i
          #puts j
          (i+1..j-1).each do |q|
            self[q].lower_index!
            #puts self
          end
          if self[j].exp == -1
              delete_letter!(j)
            else
              self[j].add_exp(1)
            end
            if self[i].exp == 1
              delete_letter!(i)
            else
              self[i].add_exp(-1)
          end
          i=0
          j=i
          #j = j+1
        else
          #j = j+1
        end
      end
      i = i+1
    end
    self
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
  
  def to_normal_form
    Word.new(self.to_s).to_normal_form!
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
