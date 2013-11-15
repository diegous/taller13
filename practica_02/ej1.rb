sum = 0

(0...1000).step(3) do |n|
  sum += n
end

(0...1000).step(5) do |n|
  sum += n
end

puts sum 
