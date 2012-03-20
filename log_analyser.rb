#!/usr/bin/env ruby

#log = open('fwlife-production-access.log', 'r')
@count = 0

@by_ip = {}
@by_action = {}
@by_urn = {}
@by_oid = {}

class Entry
  def initialize(ip, action, urn, oid)
    @ip = ip
    @action = action
    @urn = urn
    @oid = oid
  end
end

def analyse_log
  ARGF.each_line do |line|
    /(?<ip>\d+\.\d+\.\d+\.\d+).*"(?<action>\b[A-Z]{3,6}?\b).*?(?<urn>[\/\w+|:|\?|=|&\/]+)/ =~ line
    /(?<=\/)(?<oid>\w+:\w+:\w+:\d+:0)/ =~ urn  #oid   

    urn.sub!(oid, "") unless urn.nil? or oid.nil?
    track(ip, action, urn, oid)
    puts "#{urn} => #{@by_urn[urn.to_sym]}" unless urn.nil?
    @count += 1
  end
end

def track(ip, action, urn, oid)
  @by_ip[ip.to_sym] ||= 1 unless ip.nil?
  @by_action[action.to_sym] ||= 1 unless action.nil?
  @by_urn[urn.to_sym] ||= 1 unless urn.nil?
  @by_oid[oid.to_sym] ||= 1 unless oid.nil?

  unless urn.nil?
    @by_urn[urn.to_sym] = (@by_urn[urn.to_sym] += 1) if @by_urn.include?(urn.to_sym)
  end
end

def show
  puts "unique ip count: #{@by_ip.size}"
  puts "unique action count: #{@by_action.size}"
  puts "unique urn count: #{@by_urn.size}"
  puts "unique oid count: #{@by_oid.size}"

  @by_urn.sort_by {|k, v| v}.map {|urn, count| puts "#{urn} => #{count}"}
end

analyse_log 
#show
puts "count #{@count}"
