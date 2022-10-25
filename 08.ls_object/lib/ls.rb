# frozen_string_literal: true

require 'optparse'

$LOAD_PATH.unshift(__dir__)

module Ls
  autoload :FileInfoList, 'ls/file_info_list'
  autoload :FileInfo, 'ls/file_info'
  autoload :ShortFormatter, 'ls/short_formatter'
  autoload :LongFormatter, 'ls/long_formatter'
end

def parse_options
  opts = { dot: false, reverse: false, long: false, col: 3 }
  OptionParser.new do |opt_parser|
    opt_parser.on('-a') { |v| opts[:dot] = v }
    opt_parser.on('-l') { |v| opts[:long] = v }
    opt_parser.on('-r') { |v| opts[:reverse] = v }
  end.parse!(ARGV)
  opts[:paths] = ARGV
  opts
end

def ls
  opts = parse_options
  formatter = opts[:long] ? Ls::LongFormatter.new(opts) : Ls::ShortFormatter.new(opts)

  puts formatter.to_lines.join("\n")
end

ls if __FILE__ == $PROGRAM_NAME
