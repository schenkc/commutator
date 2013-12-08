require '../commutators/word_processing'

### a list of w but not w^-1 ###

input_file = File.open('commutators_in_14disk.txt', 'r')
output_file = File.new('new_commutators_in_14disk_not_redundent.txt', 'w+')

seen_hash = Hash.new

input_file.each do |line|
  b = Word.new(line.chomp!)
  b = b.to_two_generators.min_conj_class!
  inverse_word = Word.new(b.invert.to_s)
  if b.nil?
  elseif b[0].index < inverse_word[0].index
    prefered_word = b
  elsif b[0].index > inverse_word[0].index
    prefered_word = inverse_word
  end
  word = prefered_word.to_s
  if b.nil?
  elsif seen_hash[word]
#  elsif seen_hash[inverse_word]
  else
    output_file.puts word 
    seen_hash[word] = true
  end
end

input_file.close
output_file.close
