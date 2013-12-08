require '../commutators/word_processing'

source_file = File.open('./disks/8disk.txt', 'r')
output_file = File.new('commutators_in_8disk.txt', 'w+')

source_file.each do |line|
  l = line.chomp!
  a = Word.new(l)
  if a.nil?
  elsif a.in_commF?
    output_file.puts a
  else
#    puts "Not an element of the commutator subgroup"
  end
end
