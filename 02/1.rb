class Counter
  def initialize
    @store = Hash.new { |h, k| h[k] = 0 }
  end

  def count(value)
    @store[value] = @store[value] + 1
  end

  def two_of?
    @store.find { |_k, v| v == 2 }
  end

  def three_of?
    @store.find { |_k, v| v == 3 }
  end

  def reset
    @store.clear
  end
end

two_of = 0
three_of = 0
counter = Counter.new

File.foreach('input.txt') do |id|
  id.each_char { |char| counter.count(char) }

  two_of += 1 if counter.two_of?
  three_of += 1 if counter.three_of?

  counter.reset
end

puts two_of * three_of

