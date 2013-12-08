require '../commutators/word_processing'

### processes my words into the form needed for Belk's students program ###

source_file = File.open('commutators_in_16disk.txt', 'r')
output_file = File.new('xy_commutators_16disk.txt', 'w+')

source_file.each do |line|
  l = line.chomp!
  a = Word.new(l)
  a=a.to_two_generators
  puts a
  temp_word = ""
  a.each do |letter|
    if letter.to_s == "x_0"
      temp_word = temp_word + "x0"
    elsif letter.to_s == "x_1"
      temp_word = temp_word + "x1"
    elsif letter.to_s == "x_0^-1"
      temp_word = temp_word + "y0"
    elsif letter.to_s == "x_1^-1"
      temp_word = temp_word + "y1"
    end
  end
  puts temp_word
  output_file.puts temp_word
end
