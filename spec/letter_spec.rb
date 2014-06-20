require 'rspec'
require 'letter'

describe Letter do
  let(:x_0) { Letter.new(0, 1) }
  let(:x_1) { Letter.new(1, -1)}
  let(:x_10) { Letter.new(1, 0) }

  describe "#initialize" do
    it 'should set index and exponent correctly' do
      expect(x_0.index).to eq(0)
      expect(x_0.exp).to eq(1)
      expect(x_1.index).to eq(1)
      expect(x_1.exp).to eq(-1)
    end
    
    it 'should raise "bad index"' do
      expect do 
        Letter.new(-1, 1)
      end.to raise_error("Bad index, try again")
    end
    
    it 'should raise "bad exponent"' do
      expect do
        Letter.new(1, 2)
      end.to raise_error("Bad exponent, try again")
      expect do
        Letter.new(0, -2)
      end.to raise_error("Bad exponent, try again")
    end
  end
  
  describe '#to_s' do
  
    it 'returns a string' do
      expect(x_1.to_s).to be_a(String)
    end
    
    it "returns a no exponent if exp = 1" do
      expect(x_0.to_s).to eq("x_0")
    end
    
    it 'returns an empty string if exp = 0' do
      expect(x_10.to_s).to eq("x_1^0")
    end
    
    it 'returns something of the form x_5^-1' do
      expect(x_1.to_s).to eq("x_1^-1")
    end
  
  end

  describe '#to_latex' do
    
    it 'should have curly braces' do
      expect(x_0.to_latex).to eq("x_{0}")
    end
    
    it 'should be empty if exp = 0' do
      expect(x_10.to_latex).to eq('x_{1}^{0}')
    end
    
  end
  
  describe "#dup" do
    it "should make a copy of the letter" do
      expect(x_10.dup).to eq(x_10)
    end
    
    it "should be a different object" do
      expect(x_10.dup.object_id == x_10.object_id).to be_false
    end
  end

  describe '#lower_index!' do
    it 'should raise an error if index < 1' do
      expect do
        x_0.lower_index!
      end.to raise_error("Can't have negative index")
    end
    
    it 'should lower the index by 1' do
      test_letter = x_1.lower_index!
      new_index = test_letter.index
      expect(new_index).to eq(0)
    end
  end

  describe '#raise_index!' do
    it 'should raise the index by 1' do
      test_letter = x_0.raise_index!
      new_index = test_letter.index
      expect(new_index).to eq(1)
    end
  end
  
  # describe '#add_exp' do
  #   it 'should raise the exponent by the correct amount' do
  #     x_0.add_exp(3)
  #
  #     expect(x_0.exp).to eq(4)
  #   end
  # end

  describe '#invert!' do
    it 'should negate the exponent' do
      test = x_1.invert!
      expect(test.exp).to eq(1)
    end
  end

  describe '#invert' do
    it 'should return the inverse, but not change the orginal' do
      test = x_1.invert
      expect(test.exp).to eq(1)
      expect(test).to_not eq(x_1)
    end
  end

  describe '#==' do
    it 'should return true when letters are equal (but different instances)' do
      letter = Letter.new(1, -1)
      expect(x_1 == letter).to be_true
    end
    
    it 'should return false with different exponets' do
      letter = Letter.new(1,1)
      expect(letter == x_1).to be_false
    end
    
    it 'should return false with different indexs' do
      letter = Letter.new(1,1)
      expect(letter == x_0).to be_false
    end
    
    it "should return false if not a letter" do
      expect( 2 == x_0 ).to be_false
    end
  end

  describe '#inverse?' do
    it 'should return true if index is the same, and exponent inverses different' do
      letter = Letter.new(0,-1)
      expect(x_0.inverse?(letter)).to be_true
    end
    
    it 'should return false if the index is the same, and the exponents not inverses' do
      expect(x_0.inverse?(x_0)).to be_false
    end
    
    it 'should return false if different index' do
      letter = Letter.new(1,1)
      expect(x_0.inverse?(letter)).to be_false
    end
  end

  describe '#neg?' do
    it 'should return true if exp is less than 0' do
      letter = Letter.new(1,-1)
      expect(letter.neg?).to be_true
    end
    
    it 'should return false if exp is greater than 0' do
      expect(x_0.neg?).to be_false
    end
  end

  describe '#pos?' do
    it 'should return true if exp is greater than 0' do
      expect(x_0.pos?).to be_true
    end
    
    it 'should return false if exp is less than 0' do
      letter = Letter.new(1,-1)
      expect(letter.pos?).to be_false
    end
  end
end