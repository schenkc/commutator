require '../commutators/word_processing'

puts "I will search for a word in the 6disk commutatored"

search_word = Word.new(gets.chomp!)
search_word = search_word.to_normal_form!
if search_word.in_commF?
  puts "Good to go!"
else
  puts "Not a commutator.  Try again!"
  exit
end
search_word = search_word.to_s
puts search_word

search_file = File.open('6disk_commutators.txt', 'r')

search_file.each do |line|
  a = line.split(',')
  #a[0]= a[0].chomp!
#  puts a[0]
  if a[0] == search_word
    puts line
    exit
  else
#    puts "Moving on"
  end
end
