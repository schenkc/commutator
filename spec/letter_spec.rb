require 'rspec'
require 'letter'

describe Letter do
  let(:x_0) { Letter.new("x_0") }
  let(:x_10) { Letter.new("x_1^0") }
  let(:x_14) { Letter.new("x_1^4") }

  describe '#to_s' do
  
    it 'returns a string'
    it "returns a no exponent if exp = 1"
    it 'returns an empty string if exp = 0'
    it 'returns something of the form x_5^12'
  
  end

  describe '#to_latex' do
    it 'should have curly braces'
    it 'should be empty if exp = 0'
  end

  describe '#lower_index!' do
    it 'should raise an error if index < 1'
    it 'should lower the index by 1'
  end

  describe '#raise_index!' do
    it 'should raise the index by 1'
  end

  describe '#invert!' do
    it 'should negate the exponent'
  end

  describe '#invert' do
    it 'should return the inverse, but not change the orginal'
  end

  describe '#==' do
    it 'should return true when letters are equal (but different instances)'
    it 'should return false with different exponets'
    it 'should return false with different indexs'
  end

  describe '#inverse?' do
    it 'should return true if index is the same, and exponent inverses different'
    it 'should return false if the index is the same, and the exponents not inverses'
    it 'should return false if different index'
  end

  describe '#neg?' do
    it 'should return true if exp is less than 0'
    it 'should return false if exp is greater than 0'
  end

  describe '#pos?' do
    it 'should return true if exp is greater than 0'
    it 'should return false if exp is less than 0'
  end
end