require '../commutators/word_processing'

input_file = File.open("nicer_sorted_wordlist_14disk.txt", "r")
output_file = File.new("sorted_wordlist_14disk_no_inverses.txt", "w+")
seen_hash = Hash.new

input_file.each do |line|
  if line.include?("Class")
    output_file.puts line
  else
    working_line = line.gsub(/\s/, "")
    working_line = working_line.gsub!(/[x][0]/, '.x_0')
    working_line = working_line.gsub!(/[x][1]/, '.x_1')
    working_line.gsub!(/[y][0]/, '.x_0^-1')
    working_line.gsub!(/[y][1]/, '.x_1^-1')
    working_line[0]=""
    temp_word = Word.new(working_line)
    temp_word.to_normal_form!
    word = temp_word.to_s
    puts word
    inverse_temp_word = Word.new(word).invert!
    inverse_word = inverse_temp_word.to_s
    puts inverse_word
    if seen_hash[word]
    elsif seen_hash[inverse_word]
    else
      output_file.puts line
      seen_hash[word] = true
      seen_hash[inverse_word] = true
    end
  end
end
