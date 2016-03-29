#!/usr/bin/env ruby

def recursive_partition(str, sep)
  result = str.partition(sep)
  if sep != "" && result[2].match(sep)
    extra = result.pop
    result << recursive_partition(extra, sep)
  end
  result.flatten
end

filename = ARGV[0]

song = IO.readlines(filename)

songhub = []
song.map(&:rstrip).reject(&:empty?).each_slice(2) do |(line1, line2)|
  line = []
  offset = 0
  chords = recursive_partition(line1, /[A-Za-z0-9\#\/]+/).tap(&:pop)
  chords.unshift('') if chords.first.strip.length != 0
  chords.each_slice(2).with_index do |(seg1, seg2), index|
    line << line2[offset, seg1.length]
    line << "[#{seg2}]"
    line << line2[offset + seg1.length, seg2.length]
    offset += seg1.length + seg2.length
  end
  line << line2[offset..-1]
  songhub << line.join
end
puts songhub
