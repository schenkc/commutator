require 'rspec'
require 'letter'
require 'word'

describe Word do
  let(:x_0) { Word.new("x_0.x_1") }
  let(:x_10) { Letter.new("x_1^0") }
  let(:x_14) { Letter.new("x_1^4") }
  
  describe "#to_s" do
    
  end
  
  describe "#to_latex" do
    
  end
  
  describe "#[]" do
    
  end
  
  describe "#[]=" do
  end
  
  describe "#each" do
  end
  
  describe "#length" do
  end
  
  describe "#number_of_letters" do
  end
  
  describe "#eql?" do
    it "return true when the letters' order and are the same"
  end
  
  describe "#==" do
    it "return true when the group elements are equal"
  end
  
  describe "#nil?" do
    it "returns true when the word has no letters"
    it "returns false when the word has letters"
  end
  
  describe "#invert!" do
    it "does change the original word"
    it "does reverse the letter order"
    it "does negate the exponents"
  end
  
  describe "#invert" do
    it "does not change the original word"
    it "does reverse the letter order"
    it "does negate the exponents"
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