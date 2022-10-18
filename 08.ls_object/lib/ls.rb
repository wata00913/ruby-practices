# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

module Ls
  autoload :Files, 'ls/files'
  autoload :FileInfo, 'ls/file_info'
end
