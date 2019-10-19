require "test/unit"
require "pry"

TIMESTAMP_RE = /\[(\d+)-(\d+)-(\d+)\s(\d+):(\d+)\]/

Timestamp = Struct.new(:y, :m, :d, :h, :s) do
  def <=>(t2)
    each.with_index do |segment, i|
      next if segment == t2[i]
      return segment.to_i <=> t2[i].to_i
    end
    0
  end

  def to_s
    "[#{y}-#{m}-#{d} #{h}:#{s}]"
  end
end

def parse(ts_string)
  TIMESTAMP_RE.match(ts_string) do |m|
    Timestamp.new(*m.captures)
  end
end

class DayFourTest < Test::Unit::TestCase
  def test_ts_sort
    unsorted = ['[1518-11-17 00:21]', '[1518-06-13 00:02]']
    sorted = unsorted.map { |ts| parse(ts) }.sort.map(&:to_s)

    assert_equal(sorted, ['[1518-06-13 00:02]', '[1518-11-17 00:21]'])
  end
end
