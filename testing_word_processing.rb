require '../commutators/word_processing.rb'

a = Word.new("x_0.x_1.x_2^-2.x_1^-1.x_0^-1")
puts "Here is a: #{a}"
b = Word.new("x_0^2.x_5^-3")
puts "Here is b: #{b}"

pos_a = a.pos_word
puts "Here is the pos part of a #{pos_a}"
neg_a = a.neg_word
puts "Here is the neg part of a #{neg_a}"
#conj_a = a.min_conj_class
#puts "I removed unnessary junk, see: #{conj_a}"

carots = a.number_carots
puts "I think a has #{carots} carots"

c = commutate(a,b)
size = c.size
puts "Here is c: #{c} and has length #{size}"

c = c.to_normal_form!
size = c.size
new_size = c.actual_size

puts "Here is c: #{c} and has length #{size}"
puts "Here is c: #{c} and has word length (in the infinit generating set) #{new_size}"
f = c.word_length
puts "The word length should be #{f}"

puts c.in_commF?

