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
song.map(&:rstrip).reject(&:empty?).each_slice(2) do |(chords, words)|
  line = []
  offset = 0
  chords_array = recursive_partition(chords, /[A-Za-z0-9\#\/]+/).tap(&:pop)
  chords_array.unshift('') if chords_array.first.strip.length != 0
  chords_array.each_slice(2).with_index do |(seg_1, seg_2), index|
    line << words.ljust(200)[offset, seg_1.length]
    line << "[#{seg_2}]"
    line << words[offset + seg_1.length, seg_2.length]
    offset += seg_1.length + seg_2.length
  end
  line << words[offset..-1]
  songhub << line.join
end

songhub.each do |line|
  puts line.rstrip
end
