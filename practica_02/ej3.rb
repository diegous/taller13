def esPalindromo(n)
  arr = n.to_s.split('')
  len = arr.length

  (0..((len.div 2) - 1)).each do |i|
    return false unless (arr[i] == arr[len-i-1])
  end

  return true
end

max = 0

(1..999).each do |i|
  (1..999).each do |j|
      n = i*j
      max = n if (esPalindromo n) and (n > max)
    end
end

puts max
