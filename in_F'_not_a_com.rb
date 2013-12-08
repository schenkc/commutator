require '../commutators/word_processing'

index = 3
commutators = File.open("6disk_commutators.txt", "r")
subgroup_sphere = File.open("../commutators/unique_list_5.txt", "r") #from generate_spheres.rb, need change index
results = File.open("length_10_in_6disk.txt", "w+")
counter_ex_hash= Hash.new

commutators.each do |line|
  a = line.split(',')
  a[0]=a[0].chomp!
  counter_ex_hash[a[0]] = true
end

subgroup_sphere.each do |line|
  line = line.chomp!
  if counter_ex_hash[line].nil?
    results.puts line
  else
    puts "#{line} is a commutator"
  end
end


