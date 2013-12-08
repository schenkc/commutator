
### take the output of Belk's students program, and takes exactly one representitive ###

input_file = File.open("sorted_wordlist_16disk_no_inverses.txt", "r")
output_file = File.open("USEME_16disk_examples.txt", "w")

check_line = ""

input_file.each do |line|
  line.gsub!(/\s/, "")
  if line.include?("x")
    output_file.puts check_line
    output_file.puts line
  elsif line.include?("Class")
    check_line = line
  end
end
