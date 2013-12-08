require '../commutators/word_processing'

java_file = File.open('sorted_wordlist_16disk.txt', 'r')
working_file = File.new('nicer_sorted_wordlist_16disk.txt', 'w+')

conjugacy_class_number = 0

java_file.each do |line|
  if line.include?("Class")
    conjugacy_class_number = conjugacy_class_number + 1
    working_file.puts line 
  elsif line.include?("x")
    a=line.split(",")
    min_length = a[0].length
    working_word = a[0]
    a.each do |word|
      if word.length < min_length
        min_length = word.length
        working_word = word
      else
      end
    end
    working_file.puts working_word
  end
end
