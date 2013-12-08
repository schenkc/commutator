require './word_processing'

#This should write elements of F' that are not yet factored in a file

commutators = File.open("6disk_commutators.csv", "r")
elements = File.open("commutators_in_16disk.txt", "r")
result = File.open("in_16_notin6.txt" , "w+")
counter_ex_hash =Hash.new

elements.each do |line|
  counter_ex_hash[line] = true
end

commutators.each do |line|
  a = line.split(',')
  a[0]=a[0].chomp!
  counter_ex_hash.delete_if{|key, value| key == a[0] }  
end 

if counter_ex_hash.nil?
 result.puts "everything factors" 
end

counter_ex_hash.each_key {|key| results.puts key }
