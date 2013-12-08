require '../commutators/word_processing'

### this file makes a csv file of the n-disk commutated ###

results = File.open('6disk_commutators.csv', 'w+')
results.puts "commutator, c_size, x, x_size, y, y_size"

outer_loop_file = File.open('./disks/9disk.txt', 'r')
i = 0
outer_loop_file.each do |line_a|
  i = i+1
  puts "Now checking line #{i} of the first file"
  a = Word.new(line_a)
  a = a.to_normal_form!
  size_a = a.number_carots
#  length_a = a.word_length
  inner_loop_file = File.open('./disks/6disk.txt', 'r')
  inner_loop_file.each do |line_b|
    b = Word.new(line_b)
    b = b.to_normal_form!
    size_b = b.number_carots
#    length_b = b.word_length
    d = commutate(a,b).to_normal_form!
    size_d = d.number_carots
#    length_d = d.word_length
    results.puts "#{d}, #{size_d}, #{a}, #{size_a}, #{b}, #{size_b}"
  end
  inner_loop_file.close
end
outer_loop_file.close


