puts File.foreach('input.txt').reduce(0) { |sum, n| sum + n.to_i }
