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
  
  describe "#to_s" do
    it "return a string" do
      expect(a.to_s).to eq("x_0.x_1.x_0")
      expect(b.to_s).to eq("x_0^-1.x_1")
      expect(e.to_s).to eq("x_0")
    end
  end
  
  describe "#to_latex" do
    it "should read like latex" do
      expect(c.to_latex).to eq("x_{0}.x_{3}.x_{0}^{-1}")
      expect(e.to_latex).to eq("x_{0}")
    end
  end
  
  describe "#[]" do
    it "should return a letter object" do
      expect(a[0]).to be_a_kind_of(Letter)
      expect(a[0]).to eq(Letter.new("x_0"))
    end
    
  end
  
  describe "#[]=" do
    it "should replace the ith letter, with a letter" do
      a[0]=d[0]
      expect(a).to eq(Word.new("x_5^-3.x_1.x_0")) 
    end
    
    it "should add a letter to a new bin" do
      a[3] = d[0]
      expect(a).to eq(Word.new("x_0.x_1.x_0.x_5^-3"))
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
    it "returns true when the letters' order and are the same" do
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
    it "returns true when the letters' order and are the same" do
      expect(b == b_normal).to be_true
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
      expect(b[0]).to eq(Letter.new("x_1^-1"))
      expect(b[1]).to eq(Letter.new("x_0"))
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
    it "removes letter"
  end
  
  describe "#combine_like_terms!" do
    it "removes a.a^-1, a^-1.a"
  end
  
  describe "#combine_like_terms" do
    it "removes a.a^-1 and a^-1.a"
    it "does not change the original"
  end
  
  describe "#swap!(i,j)" do
    it "swaps the ith and jth letter"
  end
  
  describe "#to_normal_form!" do
    
  end
  
  describe "#in_commF?" do
    
  end
  
  describe "#word_length" do
    
  end
  
  describe "#to_two_generators" do
    
  end
  
  describe "#to_normal_form" do
    
  end
  
  describe "#pos_word" do
    
  end
  
  describe "#neg_word" do
    
  end
  
  describe "#conjucate_down!" do
    
  end
  
  describe "#number_carots" do
    
  end
end