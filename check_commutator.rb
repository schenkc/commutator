
require './word_processing'

###  search for a commutator, by taking an input, and searching an n-disk. breaking the first time the commutator is computed. ###  

puts "Please enter a element of the commutator subgroup of F"
c = Word.new(gets)
c.to_normal_form!
if c.in_commF?
else
  puts "#{c} is not in the commutator subgroup."
  puts "Please enter a commutator"
  c = Word.new(gets.chomp)
  c.to_normal_form!
  if c.in_commF?
  else
    puts "Ah! Try again.  This time by rerunning this program."
    exit
  end
end
puts c

outer_loop_file = File.open('./disks/12disk.txt', 'r')
i = 0
outer_loop_file.each do |line_a|
  i = i+1
  puts "Now checking line #{i} of the first file"
  a = Word.new(line_a)
  a = a.to_normal_form!
  inner_loop_file = File.open('./disks/12disk.txt', 'r')
  inner_loop_file.each do |line_b|
    b = Word.new(line_b)
    b = b.to_normal_form!
    d = commutate(a,b).to_normal_form!
    if d == c
      results = File.open("#{c}_results.tex", 'w+')
      results.puts "#{c} is a commutator with factors:"
      results.puts a
      results.puts b
      results.close
      inner_loop_file.close
      outer_loop_file.close
      exit
    end
#    break if d == c
  end
  inner_loop_file.close
end
outer_loop_file.close

