require 'set'

Tag = Struct.new(:id, :margin_l, :margin_t, :width, :height)

def run
  tagged_inches = {} # { [x, y] => [tag_id, tag_id ...] }

  File.foreach('input.txt', chomp: true) do |tag_string|
    tag = create_tag(tag_string)

    inch_coords_for(tag).each do |inch|
      tagged_inches[inch] = tagged_inches.fetch(inch, Set.new) << tag.id
    end
  end

  # Could refactor for single pass
  puts "Overlapping: #{overlap_count(tagged_inches.values)}"
  puts "Uniq tag ID: #{uniq_tag(tagged_inches.values)}"
end

def create_tag(tag_string)
  matches = /(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/.match(tag_string) do |m|
    Tag.new(*m.captures.map(&:to_i))
  end
end

# [[2,3], [2,4] ...]
def inch_coords_for(tag)
  x, y  = tag.margin_l, tag.margin_t
  row   = (x...x + tag.width).to_a
  col   = (y...y + tag.height).to_a

  row.flat_map do |x|
    Array.new(col.length, x).zip(col)
  end
end

def overlap_count(tag_sets_by_inch)
  tag_sets_by_inch.count { |tag_set| tag_set.length > 1 }
end

def uniq_tag(tag_sets_by_inch)
  all_tags, invalid_tags = Set.new, Set.new

  tag_sets_by_inch.each do |tag_set|
    invalid_tags = invalid_tags | tag_set if tag_set.length > 1
    all_tags = all_tags | tag_set
  end

  (all_tags - invalid_tags).first
end

run
