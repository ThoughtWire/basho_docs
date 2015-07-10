#!/usr/bin/env ruby

require 'optparse'

envs = {}
envs['RIAK_DOCS_LANG'] = 'en'
envs['DEPLOY'] = "true"

OptionParser.new do |opt|
  opt.on('-r', '--riak RIAK_VERSION') { |o| envs['RIAK_VERSION'] = o }
  opt.on('-c', '--riakcs RIAKCS_VERSION') { |o| envs['RIAKCS_VERSION'] = o }
  opt.on('-q', '--dry-run', 'Build, but don\'t deploy to S3') { |o| envs['DEPLOY'] = "false" }
  opt.on('-h', 'Display this help message') { puts opt; exit }
end.parse!

`rm -rf build`

if (envs['DEPLOY'] == "true" && (
    "#{ENV['AWS_ACCESS_KEY_ID']}" == '' ||
    "#{ENV['AWS_CLOUDFRONT_DIST_ID']}" == '' ||
    "#{ENV['AWS_S3_BUCKET']}" == '' ||
    "#{ENV['AWS_SECRET_ACCESS_KEY']}" == ''))
  puts "Required env vars for this script:"
  puts "    AWS_ACCESS_KEY_ID"
  puts "    AWS_CLOUDFRONT_DIST_ID"
  puts "    AWS_S3_BUCKET"
  puts "    AWS_SECRET_ACCESS_KEY"
  puts ""
end

system envs, "bundle exec middleman build"
