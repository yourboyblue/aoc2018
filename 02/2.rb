checks = {}

File.foreach('input.txt') do |id|
  id = id.rstrip!

  id.each_char.with_index do |_l, i|
    chars = id.dup
    chars[i] = '0'

    checks[chars] = [] if checks[chars].nil?
    checks[chars] << id

    puts chars.tr('0', '') if checks[chars].length > 1
  end
end
