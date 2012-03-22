#!/usr/bin/env ruby 

unless ARGV.size == 2
  puts "usage: #{__FILE__} <project name> <branch name>"
  puts "example1: #{__FILE__} gps remotes/origin/release-gls-2.14"
  puts "example2: #{__FILE__} source/gls-rest-api-tests remotes/origin/release-gls-2.14"
  exit
end

project = ARGV[0] 
source_branch = ARGV[1] 

def run_in_dir(dir)
  cwd = Dir.pwd
  Dir.chdir dir
  return yield if block_given?
  Dir.chdir cwd
end

def recent_commits(branch)
  `git fetch && git log --pretty=oneline --since="2 week ago" #{branch}`
end

def find_recent_commits(branch)
  sha_map = {}
  commits = recent_commits(branch).split("\n").map do |commit| 
    /(?<sha>^\w+(?=\s?)) (?<msg>.*$)/=~ commit
    sha_map[sha] = msg 
  end
  sha_map
end

def branches_containing(sha)
  results = `git branch -a --contains #{sha}`
  branch_names = results.split("\n").collect do |branch| 
    /(?<branch_name>[^*^\s].*)/ =~ branch
    branch_name
  end
  branch_names
end

def find_branches_for_recent_commits(project, branch)
  dir = "/home/r2d2/#{project}"
  recent_commits = run_in_dir(dir) {find_recent_commits(branch)}
  recent_commits.each do |sha, msg|
    branches_including_sha = run_in_dir(dir) { branches_containing(sha) }
    printf "\n%s : %s %s\n"%[sha, msg, format_branches(branches_including_sha)]
  end
end

def format_branches(branches)
  printf "\t%s\n"%[branches.join("\n\t")]
end

find_branches_for_recent_commits(project, source_branch)
