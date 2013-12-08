require '../commutators/word_processing'

puts "I will search for a word in the 9disk commutatored"


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
output = File.new("#{search_word}.txt", 'w+')
search_file = File.open('9disk_commutators.csv', 'r')

search_file.each do |line|
  a = line.split(',')
  #a[0]= a[0].chomp!
#  puts a[0]
  if a[0] == search_word
    output.puts line
#    exit
  else
#    puts "Moving on"
  end
end
output.close
search_file.close
