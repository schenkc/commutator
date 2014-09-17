require 'rspec'
require 'letter'
require 'word'

describe Word do
  let(:a) { Word.new("x_0.x_1.x_0") }
  
  let(:b) { Word.new("x_0^-1.x_1") }
  let(:b_normal) { Word.new("x_2.x_0^-1") }
  
  let(:c) { Word.new("x_0.x_3.x_0^-1") }
  let(:d) { Word.new("x_5^-3") }
  let(:e) { Word.new("x_0") }
  let(:empty) { Word.new("") }
  
  describe "#initalize" do
    
  end
  
  describe "::parse_letter_data" do
    it "should set index and exponent correctly" do
      expect(Word.parse_letter_data("x_0")).to eq([Letter.new(0,1)])
      expect(Word.parse_letter_data("x_1^-1")).to eq([Letter.new(1,-1)])
      expect(Word.parse_letter_data("x_2^0")).to eq([Letter.new(2,0)])
    end
    
    it 'should raise "poorly formed expression"' do
      expect do
        Word.parse_letter_data("x_^")
      end.to raise_error("Poorly formed expression, try again")
      
      expect do
        Word.parse_letter_data("x_1^a")
      end.to raise_error("Poorly formed expression, try again")
      
      expect do
        Word.parse_letter_data("x_0^")
      end.to raise_error("Poorly formed expression, try again")
    end
  end
  
  describe "#to_s" do
    it "return a string" do
      expect(a.to_s).to eq("x_0.x_1.x_0")
      expect(b.to_s).to eq("x_0^-1.x_1")
      expect(d.to_s).to eq("x_5^-3")
      expect(e.to_s).to eq("x_0")
    end
  end
  
  describe "#to_latex" do
    it "should read like latex" do
      expect(c.to_latex).to eq("x_{0}.x_{3}.x_{0}^{-1}")
      expect(d.to_latex).to eq("x_{5}^{-3}")
      expect(e.to_latex).to eq("x_{0}")
    end
  end
  
  describe "#[]" do
    it "should return a letter object" do
      expect(a[0]).to be_a_kind_of(Letter)
      expect(a[0]).to eq(Letter.new(0,1))
    end
    
  end
  
  describe "#[]=" do
    it "should replace the ith letter, with a letter" do
      a[0]=d[0]
      expect(a).to eq(Word.new("x_5^-1.x_1.x_0")) 
    end
    
    it "should add a letter to a new bin" do
      a[3] = d[0]
      expect(a).to eq(Word.new("x_0.x_1.x_0.x_5^-1"))
    end
  end
  
  describe "#<<" do
    it "should add a letter on the end of the letters array" do
      l = Letter.new(0,1)
      expect(a << l).to eq(Word.new("x_0.x_1.x_0^2"))
    end
    
    it "should raise raise error if not a letter" do
      expect do
        a << d
      end.to raise_error("Can only append a letter object")
    end
  end
  
  describe "#*" do
    it "should multiple two words" do
      expect(a * c).to eq(Word.new("x_0.x_1.x_0.x_0.x_3.x_0^-1"))
    end
    
    it "should treat a letter as a word" do
      l = Letter.new(0,1)
      expect(a * l).to eq(Word.new("x_0.x_1.x_0^2"))
    end
    
    it "should understand the empty word" do
      empty = Word.new
      expect(empty * a).to eq(a)
    end
  end
  
  describe "#each" do
    it "should take a block"
    
    # ask how expect can take a block.
    it "should return the word" do
      w = a.each { |x| x.invert }
      
      expect(w).to eq(a)
    end
  end
  
  describe "#dup" do
    it "should make a copy of the word" do
      expect(b.dup).to eq(b)
    end
    
    it "should be a different object" do
      expect(b.dup.object_id == b.object_id).to be_false
    end
  end
  
  describe "#number_of_letters" do
    it "should add exponents" do
      expect(b.number_of_letters).to eq(2)
      expect(c.number_of_letters).to eq(3)
    end
    
    it "should deal with the empty word" do
      expect(empty.number_of_letters).to eq(0)
    end
  end
  
  describe "#different_representation?" do
    it "returns true when words are equivalent" do
      expect(b.different_representation?(b_normal)).to be_true
    end
    
    it "returns false when the words are not equivalent" do
      expect(a.different_representation?(b)).to be_false
    end
    
    it "returns false when the words are identical as letters" do
      expect(a.different_representation?(a)).to be_false
    end
  end
  
  describe "#==" do
    it "returns false with different representations" do
      expect(b == b_normal).to be_false
    end
    
    it "returns false when the words are not equivalent" do
      expect(a == b).to be_false
    end
    
    it "returns true when the words are identical as letters" do
      q = Word.new("x_0.x_1.x_0")
      expect(a == q).to be_true
    end
  end
  
  describe "#nil?" do
    it "returns true when the word has no letters" do
      expect(empty.nil?).to be_true
    end
    
    it "returns false when the word has letters" do
      expect(a.nil?).to be_false
    end
  end
  
  describe "#invert!" do
    it "does change the original word" do
      expect(a.invert!).to eq(a)
    end
    it "does reverse the letter order and negate exponents" do
      b.invert! # b = x_0^-1.x_1, b^-1 = x_1^-1.x_0
      expect(b[0]).to eq(Letter.new(1, -1))
      expect(b[1]).to eq(Letter.new(0, 1))
    end
    
  end
  
  describe "#invert" do
    it "does not change the original word" do
      b.invert
      expect(b).to eq(b)
    end
    
    it "does reverse the letter order and negate exponents" do
      expect(b.invert).to eq(Word.new("x_1^-1.x_0"))
    end
  end
  
  describe "#delete_letter!" do 
    it "removes letter" do
      b.delete_letter!(0)
      expect(b).to eq(Word.new("x_1"))
    end
  end
  
  describe "#combine_like_terms!" do
    it "removes a.a^-1" do
      word = Word.new("x_0.x_0^-1")
      word.combine_like_terms!
      expect(word.nil?).to be_true
      
      other_word = Word.new("x_0.x_0^-1.x_1")
      other_word.combine_like_terms!
      expect(other_word).to eq(Word.new("x_1"))
      
      another_word = Word.new("x_1.x_0.x_0^-1.x_3")
      another_word.combine_like_terms!
      expect(another_word).to eq(Word.new("x_1.x_3"))
    end
    
    it "removes a^-1.a" do
      word = Word.new("x_0^-1.x_0")
      word.combine_like_terms!
      expect(word.nil?).to be_true
      
      other_word = Word.new("x_0^-1.x_0.x_1")
      other_word.combine_like_terms!
      expect(other_word).to eq(Word.new("x_1"))
      
      another_word = Word.new("x_1.x_0^-1.x_0.x_3")
      another_word.combine_like_terms!
      expect(another_word).to eq(Word.new("x_1.x_3"))
    end
    
    it "removes a^0" do
      word = Word.new("x_0^0.x_1")
      expect(word.combine_like_terms!).to eq(Word.new("x_1"))
    end
  end
  
  describe "#combine_like_terms" do
    it "removes a.a^-1" do
      word = Word.new("x_0.x_0^-1")
      w = word.combine_like_terms
      expect(w.nil?).to be_true
      
      other_word = Word.new("x_0.x_0^-1.x_1")
      ow = other_word.combine_like_terms
      expect(ow).to eq(Word.new("x_1"))
      
      another_word = Word.new("x_1.x_0.x_0^-1.x_3")
      aw = another_word.combine_like_terms
      expect(aw).to eq(Word.new("x_1.x_3"))
    end
    
    it "removes a^-1.a" do
      word = Word.new("x_0^-1.x_0")
      w = word.combine_like_terms
      expect(w.nil?).to be_true
      
      other_word = Word.new("x_0^-1.x_0.x_1")
      ow = other_word.combine_like_terms
      expect(ow).to eq(Word.new("x_1"))
      
      another_word = Word.new("x_1.x_0^-1.x_0.x_3")
      aw = another_word.combine_like_terms
      expect(aw).to eq(Word.new("x_1.x_3"))
    end
    
    it "does not change the original" do
      another_word = Word.new("x_1.x_0^-1.x_0.x_3")
      another_word.combine_like_terms
      expect(another_word).to eq(Word.new("x_1.x_0^-1.x_0.x_3"))
    end
      
  end
  
  describe "#swap!(i,j)" do
    it "swaps the ith and jth letter" do
      expect(c.swap!(0,1)).to eq(Word.new("x_3.x_0.x_0^-1"))
    end
    
    it "doesn't swap letters if one of the numbers is out of bounds" do
      expect(c.swap!(0,5)).to eq(c)
    end
  end
  
  describe "#move_right(i)" do
    it "words of length 1 shoud be unchanged" do
      expect(e.move_right(0)).to eq(Word.new("x_0"))
    end
    
    it "raise an error if i is bigger than the letters array" do
      expect do
        a.move_right(3)
      end.to raise_error("No letter to move.")
    end
    
    describe "when both letters are positive" do
      it "both letters have equal index" do
        word = Word.new("x_0.x_0")
        expect(word.move_right(0)).to eq(Word.new("x_0.x_0"))
      end
      
      it "big then little" do
        word = Word.new("x_1.x_0")
        expect(word.move_right(0)).to eq(Word.new("x_0.x_2"))
      end
      
      it "little then big and different greater than 1" do
        word = Word.new("x_0.x_2")
        expect(word.move_right(0)).to eq(Word.new("x_1.x_0"))
      end
      
      it "little then big and difference equal to 1" do
        # word = Word.new("x_0.x_1.x_0") == a
        expect(a.move_right(0)).to eq(Word.new("x_1.x_0.x_0^-1.x_1^-1.x_0.x_1.x_0"))
        a = Word.new("x_0.x_1.x_0")
        expect(a.move_right(0, :left)).to eq(Word.new("x_0.x_1.x_0^-1.x_1^-1.x_1.x_0.x_0"))
      end
    end
    
    describe "when both letters are negitive" do
      it "both letters have equal index" do
        word = Word.new("x_0^-1.x_0^-1")
        expect(word.move_right(0)).to eq(Word.new("x_0^-1.x_0^-1"))
      end
      
      it "little then big" do
        word = Word.new("x_0^-1.x_1^-1")
        expect(word.move_right(0)).to eq(Word.new("x_2^-1.x_0^-1"))
      end
      
      it "big then little and different greater than 1" do
        word = Word.new("x_2^-1.x_0^-1")
        expect(word.move_right(0)).to eq(Word.new("x_0^-1.x_1^-1"))
      end
      
      it "big then little and difference equal to 1" do
        word = Word.new("x_1^-1.x_0^-1")
        expect(word.move_right(0)).to eq(Word.new("x_1^-1.x_0^-1.x_1.x_0.x_0^-1.x_1^-1"))
        word = Word.new("x_1^-1.x_0^-1")
        expect(word.move_right(0, :left)).to eq(Word.new("x_0^-1.x_1^-1.x_1.x_0.x_1^-1.x_0^-1"))
      end
      
    end
    
    describe "the first letter is negitive and the second positive" do
      it "big then little" do
        word = Word.new("x_1^-1.x_0")
        expect(word.move_right(0)).to eq(Word.new("x_0.x_2^-1"))
      end
      
      it "little then big" do
        word = Word.new("x_0^-1.x_1")
        expect(word.move_right(0)).to eq(Word.new("x_2.x_0^-1"))
      end
      
      it "equal index on both" do
        word = Word.new("x_0^-1.x_0")
        expect(word.move_right(0)).to eq(Word.new("x_0.x_0^-1"))
      end
    end
    
    describe "the first letter is positive and the second it negitive" do
      describe "the difference between indexes is greater than 1" do
        it "big then little" do
          word = Word.new("x_5.x_3^-1")
          expect(word.move_right(0)).to eq(Word.new("x_3^-1.x_4"))
        end
        
        it "little than big" do
          word = Word.new("x_3.x_5^-1")
          expect(word.move_right(0)).to eq(Word.new("x_4^-1.x_3"))
        end
      end
      
      describe "the difference between the indexes is 1" do
        it "big then little" do
          word = Word.new("x_4.x_3^-1")
          expect(word.move_right(0)).to eq(Word.new("x_3^-1.x_4.x_4^-1.x_3.x_4.x_3^-1"))
          word = Word.new("x_4.x_3^-1")
          expect(word.move_right(0, :left)).to eq(Word.new("x_4.x_3^-1.x_4^-1.x_3.x_3^-1.x_4"))
        end
        
        it "little then big" do
          word = Word.new("x_3.x_4^-1")
          expect(word.move_right(0)).to eq(Word.new("x_4^-1.x_3.x_3^-1.x_4.x_3.x_4^-1"))
          word = Word.new("x_3.x_4^-1")
          expect(word.move_right(0, :left)).to eq(Word.new("x_3.x_4^-1.x_3^-1.x_4.x_4^-1.x_3"))
        end
      end
      
      describe "the indexes are equal" do
        it "swap letters" do
          word = Word.new("x_4.x_4^-1")
          expect(word.move_right(0)).to eq(Word.new("x_4^-1.x_4"))
        end
      end
    end
  end
  
  describe "#to_normal_form!" do
    it "words in normal form should be unchanged" do
      a1 = Word.new("x_0.x_1")
      expect(a1.to_normal_form!).to eq(Word.new("x_0.x_1"))
    end
    
    it "can deal with positive words" do
      a2 = Word.new("x_1.x_0")
      expect(a2.to_normal_form!).to eq(Word.new("x_0.x_2"))
    end
    
    it "can move negitive letters all the way to the right" do
      a3 = Word.new("x_0^-1.x_2.x_0")
      expect(a3.to_normal_form!).to eq(Word.new("x_3"))
      
      a10 = Word.new("x_1^-1.x_2.x_0")
      expect(a3.to_normal_form!).to eq(Word.new("x_0.x_4.x_2^-1"))
    end
    
    it "words in formal form should be unchanged" do
      a4 = Word.new("x_1^-1.x_0^-1")
      expect(a4.to_normal_form!).to eq(Word.new("x_1^-1.x_0^-1"))
    end
    
    it "can deal with negitive words" do
      a5 = Word.new("x_0^-1.x_1^-1")
      expect(a5.to_normal_form!).to eq(Word.new("x_2^-1.x_0^-1"))
    end
    
    it "can deal with multiple conjugate downs" do
      a6 = Word.new("x_0.x_1.x_5^-1.x_3^-2.x_1^-1.x_0^-1")
      expect(a6.to_normal_form!).to eq(Word.new("x_5^-1.x_1^-2"))
    end
    
    it "can deal with big exponents" do
      a7 = Word.new("x_0^-1.x_2^5.x_3.x_1^-1")
      expect(a7.to_normal_form!).to eq(Word.new("x_3^5.x_4.x_2^-1.x_0^-1"))
      a8 = Word.new("x_0^-1.x_3.x_2^5.x_1^-1")
      expect(a7.to_normal_form!).to eq(Word.new("x_3^5.x_9.x_2^-1.x_0^-1"))
    end
    
  end
  
  describe "#in_commF?" do
    describe "should deal with words in normal form" do
      it "should return true if in commutator subgroup" do
        c1 = Word.new("x_0^2.x_1.x_2^-1.x_0^-2")
        expect(c1.in_commF?).to be_true
      end
      
      it "should return false if not in the commutator subgroup" do
        c2 = Word.new("x_0.x_1.x_2^-2")
        expect(c2.in_commF?).to be_false
      end
    end
    
    describe "should deal with words not in normal form" do
      it "should return true if in commutator subgroup" do
        c3 = Word.new("x_0^-1.x_1.x_4^-1.x_0")
        expect(c3.in_commF?).to be_true
      end
      
      it "should return false if not in the commutator subgroup" do
        c4 = Word.new("x_1^-1.x_2^2")
        expect(c4.in_commF?).to be_false
      end
    end
  end
  
  describe "#word_length" do
    
  end
  
  describe "#to_two_generators" do
    
  end
  
  describe "#to_normal_form" do
    
  end
  
  describe "#pos_word" do
    it "should return the whole word (in normal form) when pos" do
      w = Word.new("x_1.x_0")
      expect(w.pos_word).to eq(Word.new("x_0.x_2"))
    end
    
    it "should return the empty word if word in neg" do
      w = Word.new("x_1^-1")
      expect(w.pos_word).to eq(Word.new(""))
    end
    
    it "should return just the positive part" do
      w = Word.new("x_0.x_3.x_6^-1.x_1^-1")
      expect(w.pos_word).to eq(Word.new("x_0.x_3"))
    end
  end
  
  describe "#neg_word" do
    it "should return the whole word (in normal form) when neg" do
      w = Word.new("x_0^-1.x_1^-1")
      expect(w.neg_word).to eq(Word.new("x_2^-1.x_0^-1"))
    end
    
    it "should return the empty word if word in pos" do
      w = Word.new("x_1")
      expect(w.neg_word).to eq(Word.new(""))
    end
    
    it "should return just the positive part" do
      w = Word.new("x_0.x_3.x_6^-1.x_1^-1")
      expect(w.neg_word).to eq(Word.new("x_6^-1.x_1^-1"))
    end
  end
  
  describe "#conjucate_down!" do
    
  end
  
  describe "#number_carots" do
    describe "should be able to use words in normal form" do
      it "should be able to deal with pos words" do
        w1 = Word.new("x_0.x_1.x_2")
        expect(w1.number_carots).to eq(4)
      end
      
      it "should be able to deal with neg words" do
        w2 = Word.new("x_5^-1.x_2^-1.x_2^-1")
        expect(w2.number_carots).to eq(6)
      end
      
      it "should be able to deal with mixed words" do
        w3 = Word.new("x_0.x_1.x_2.x_5^-1.x_2^-1.x_2^-1")
        expect(w3.number_carots).to eq(6)
      end
    end
    
    describe "should be able to use words not in normal form" do
      it "should be able to deal with pos words" do
        w1 = Word.new("x_2.x_1")
        expect(w1.number_carots).to eq(5)
      end
      
      it "should be able to deal with neg words" do
        w2 = Word.new("x_0^-1.x_4^-1.x_1^-1")
        expect(w2.number_carots).to eq(7)
      end
      
      it "should be able to deal with messes of letters" do
        w3 = Word.new("x_4^-1.x_0.x_1^-1.x_2")
        expect(w3.number_carots).to eq(8)
      end
    end
    
  end
end