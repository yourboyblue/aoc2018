require "test/unit"

INPUT = File.read('input.txt').strip

def sanitize_polymer(polymer)
  current = polymer.head
  while current.right
    if current.match?
      current = polymer.destroy(current)
      current = polymer.destroy(current)

      break if current.nil?
      current = current.left if current.left
    else
      current = current.right
    end
  end
  polymer
end

class Polymer
  def initialize(chars)
    @head = nil
    left, right = nil, nil
    chars_e = chars.each_char

    while true do
      type = chars_e.next
      right = Unit.new(left, nil, type)
      @head = right if left.nil?
      left.right = right if left
      left = right
    end
  rescue StopIteration
  end

  attr_reader :head

  def destroy(unit)
    new_left, new_right = unit.left, unit.right
    @head = new_right if unit == @head

    new_right.left = new_left if new_right
    new_left.right = new_right if new_left

    return @head if new_left.nil?
    return new_right if new_right
    new_left
  end

  def to_s
    str = ''
    return str if @head.nil?

    current_unit = @head
    while current_unit do
      str << current_unit.type
      current_unit = current_unit.right
    end

    str
  end
end

Unit = Struct.new(:left, :right, :type) do
  def match?
    return false if right.nil?
    (type.ord - right.type.ord).abs == 32
  end
end

puts sanitize_polymer(Polymer.new(INPUT)).to_s.length

class DayFiveTest < Test::Unit::TestCase
  def test_unit_match
    polymer = Polymer.new('Aa')
    left = polymer.head

    assert_equal(left.match?, true)
  end

  def test_unit_no_match
    polymer = Polymer.new('Ab')
    left = polymer.head

    assert_equal(false, left.match?,)
  end

  def test_polymer_to_s
    polymer = Polymer.new('AbMeweGSDfsdsf')
    assert_equal('AbMeweGSDfsdsf', polymer.to_s)
  end

  def test_sanitizing
    polymer = Polymer.new('AaMeeeeeeGgH')
    sanitized = sanitize_polymer(polymer).to_s
    assert_equal('MeeeeeeH', sanitized)
  end

  def test_end_pair
    polymer = Polymer.new('AGg')
    sanitized = sanitize_polymer(polymer).to_s
    assert_equal('A', sanitized)
  end

  def test_collapse
    polymer = Polymer.new('AGgaB')
    sanitized = sanitize_polymer(polymer).to_s
    assert_equal('B', sanitized)
  end

  def test_self_destruct
    polymer = Polymer.new('AGga')
    sanitized = sanitize_polymer(polymer).to_s
    assert_equal('', sanitized)
  end
end
