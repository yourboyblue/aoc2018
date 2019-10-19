require 'set'

fluctuations = File.read('input.txt').split("\n").map(&:to_i)
found = Set.new
searching = true
sum = 0

while searching do
  fluctuations.each do |n|
    if found.include?(sum)
      searching = false
      break
    end

    found << sum
    sum += n
  end
  redo if searching
end

puts sum


