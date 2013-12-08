require '../commutators/word_processing'

A = File.open('commutators_in_12disk_not_redundent.txt', 'r')
B = File.open('commutators_in_10disk_not_redundent.txt', 'r')
C = File.new('small_commutators_in_12-10disk.txt', 'w+')

seen_hash = Hash.new

A.each do |line|
  line.chomp!
  seen_hash[line] = true
end

B.each do |line|
  line.chomp!
  seen_hash[line] = false
end

seen_hash.each do | element, bool |
  if bool == false
  elsif bool == true
    C.puts element
  end
end

A.close
B.close
C.close
