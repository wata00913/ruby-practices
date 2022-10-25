# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

module Ls
  autoload :Files, 'ls/files'
  autoload :FileInfo, 'ls/file_info'
  autoload :ShortFormatter, 'ls/short_formatter'
  autoload :LongFormatter, 'ls/long_formatter'
end
