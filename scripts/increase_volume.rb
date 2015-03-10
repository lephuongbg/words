#!/usr/bin/env ruby
# encoding: utf-8
#
# INCREASE VOLUME OF SOUND FILES AS MUCH AS POSSIBLE
# WITHOUT DISTORTING SIGNALS
#
# Usage: Run the script in each sound directory
#
require 'parallel'

Parallel.each(Dir.glob("*.wav"), in_thread: 4, progress: "Increasing volume...") do |word|
  adjustment = `sox #{word} -n stat -v 2>&1`.to_f
  if adjustment > 2
    adjustment = adjustment - 1
  end
  new_name = File.basename(word, '.wav') + '.new.wav'
  %x[sox #{word} -G #{new_name} vol #{adjustment}]
  %x[mv #{new_name} #{word}]
end
