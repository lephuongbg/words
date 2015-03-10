#!/usr/bin/env ruby
# encoding: utf-8
#
# DOWNSAMPLE SOUND FILES TO mono, 16Khz, 16-bit
#
# Usage: Run the script in each sound directory
#

require 'parallel'

Parallel.each(Dir.glob("*.wav"), progress: 'Downsampling files...', in_threads: 4) do |word|
  new_name = File.basename(word, '.wav') + '.new.wav'
  system("sox #{word} -b 16 -G #{new_name} channels 1 rate 16k")
  system("mv #{new_name} #{word}")
end
