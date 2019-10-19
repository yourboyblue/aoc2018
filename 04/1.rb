require "test/unit"
require "pry"

ENTRY_REGEXP = /\[(\d+)-(\d+)-(\d+)\s(\d+):(\d+)\]\s(.*)/

def run
  lines = File.read('input.txt').split("\n")
  sorted_entries = lines.map { |l| parse(l) }.sort
end

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
  ENTRY_REGEXP.match(ts_string) do |m|
    return [Timestamp.new(*m.captures[0..4]), m.captures[-1]]
  end
end

class Entry
  def initialize(timestamp, description)
    @timestamp = timestamp
    @description = description
  end

  attr_reader :timestamp

  def <=>(e2)
    timestamp <=> e2.timestamp
  end

  def shift_change?
    /#\d+/.match?(@description)
  end
end

run

class DayFourTest < Test::Unit::TestCase
  def test_ts_sort
    unsorted = ['[1518-11-17 00:21] wakes up', '[1518-06-13 00:02] wakes up']
    sorted = unsorted.map { |ts| parse(ts)[0] }.sort.map(&:to_s)

    assert_equal(sorted, ['[1518-06-13 00:02]', '[1518-11-17 00:21]'])
  end
end
