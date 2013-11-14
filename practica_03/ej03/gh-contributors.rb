require 'rubygems'
require 'bundler/setup'
require 'octokit'

if ARGV.size < 1
  puts 'Parameter as user/repository'
else
  repo = Octokit.repo ARGV[0] 
  puts 'Contributions for ' + ARGV[0]

  repo[:rels][:contributors].get.data.each do |user|
    puts '* ' + user[:login] + ' (' + user[:contributions].to_s + ')'
  end
end

