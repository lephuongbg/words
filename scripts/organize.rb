#!/usr/bin/env ruby
# encoding: utf-8
#
# ORGANIZE SOUND FILES INTO TONE-NAMED FOLDERS
#
# Usage: Run the script in each sound directory
#
require 'fileutils'
require 'parallel'

def diacritic(word)
  case word
  when /[áắấéếíóốớúứý]/
    'acute'
  when /[àằầèềìòồờùừỳ]/
    'grave'
  when /[ảẳẩẻểỉỏổởủửỷ]/
    'hook'
  when /[ãẵẫẽễĩõỗỡũữỹ]/
    'tilde'
  when /[ạặậẹệịọộợụựỵ]/
    'dot'
  else
    'unmarked'
  end
end

%w(acute grave hook tilde dot unmarked).each do |diacritic|
  if !Dir.exists?(diacritic)
    Dir.mkdir(diacritic)
  end
end

Parallel.each(Dir.glob('*.wav'), progress: 'Organizing files...', in_threads: 4) do |word|
  FileUtils.mv word, diacritic(word) + "/"
end
