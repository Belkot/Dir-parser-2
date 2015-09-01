require_relative "dirparse.rb"

puts Dirparse.new (ARGV[0] || ".")
