require "test/unit"

LINES = File.read('input.txt').split("\n").freeze
ENTRY_REGEXP = /\[(\d+)-(\d+)-(\d+)\s(\d+):(\d+)\]\s(.*)/

class DayFour
  def initialize(lines=LINES)
    @naps = nap_log(sorted_entries(lines))
  end

  def get_checksum
    id, minutes_arr = @naps.sort_by { |k, v| v.length }.last
    best_minute = minutes_arr.group_by { |i| i }.values.max { |a,b| a.length <=> b.length }.first
    return id.to_i * best_minute.to_i
  end

  def get_checksum2
    checks = {} # { [guard_id, min] => min_count }
    @naps.each do |guard, nap_minutes|
      nap_minutes.each do |minute|
        checks[[guard, minute]] = checks.fetch([guard, minute], 0) + 1
      end
    end

    id, most_napped_minute = checks.sort_by(&:last).last.first
    return id.to_i * most_napped_minute.to_i
  end

  def sorted_entries(lines=LINES)
    entries = lines.map do |line|
      timestamp, description = parse(line)
      Entry.new(timestamp, description)
    end
    sorted_entries = entries.sort.each
  end

  # { guard_id => [min, min, min...] }
  def nap_log(sorted_entries)
    naps = {}
    guard_on_shift = nil

    while true do
      current_e = sorted_entries.next

      guard_on_shift = current_e.guard_id and next if current_e.shift_change?
      next unless current_e.nap_start?

      nap_beg, nap_end = current_e, sorted_entries.next
      record_nap(guard_on_shift, nap_beg, nap_end, naps)
    end
  rescue StopIteration
    naps
  end

  def parse(ts_string)
    ENTRY_REGEXP.match(ts_string) do |m|
      return [Timestamp.new(*m.captures[0..4]), m.captures[-1]]
    end
  end

  def record_nap(guard_id, e1, e2, naps = {})
    naps[guard_id] = naps.fetch(guard_id, []) + (e1.timestamp.m...e2.timestamp.m).to_a
  end
end

Timestamp = Struct.new(:y, :mm, :dd, :h, :m) do
  def <=>(t2)
    each.with_index do |segment, i|
      next if segment == t2[i]
      return segment.to_i <=> t2[i].to_i
    end
    0
  end

  def to_s
    "[#{y}-#{mm}-#{dd} #{h}:#{m}]"
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
    !guard_id.nil?
  end

  def nap_start?
    'falls asleep'.match?(@description)
  end

  def guard_id
    /(\d+)/.match(@description) { |m| m[0] }
  end
end

day = DayFour.new
puts "Part 1: #{day.get_checksum}"
puts "Part 2: #{day.get_checksum2}"

class DayFourTest < Test::Unit::TestCase
  def test_ts_sort
    unsorted = ['[1518-11-17 00:21] wakes up', '[1518-06-13 00:02] wakes up']
    sorted = unsorted.map { |ts| DayFour.new.parse(ts)[0] }.sort.map(&:to_s)

    assert_equal(sorted, ['[1518-06-13 00:02]', '[1518-11-17 00:21]'])
  end

  def test_checksum
    assert_equal(DayFour.new.get_checksum, 39422)
  end

  def test_checksum2
    assert_equal(DayFour.new.get_checksum2, 65474)
  end
end
