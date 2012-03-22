#!/usr/bin/env ruby 

unless ARGV.size == 1
  puts "usage: #{__FILE__} <project name>"
  exit
end

project = ARGV[0] 
cwd = `pwd`
Dir.chdir '/home/r2d2/gps'
result = `git log --pretty=oneline --since="2 week ago"`
sha_map = {}
commits = result.split("\n").map do |commit| 
  /(?<sha>^\w+(?=\s?)) (?<msg>.*$)/=~ commit
  sha_map[sha] = msg 
end

def branches_containing(sha)
  results = `git branch -a --contains #{sha}`
  branch_names = results.split("\n").collect do |branch| 
    /(?<branch_name>[^*^\s].*)/ =~ branch
    branch_name
  end
  branch_names
end

def format_branches(branches)
  printf "\t%s\n"%[branches.join("\n\t")]
end

sha_map.each do |sha, msg|
  printf "\n%s : %s %s\n"%[sha, msg, format_branches(branches_containing(sha))]
end
