require 'pathname'

module Code42Template
  RAILS_VERSION = "~> 5.0.0"
  RUBY_VERSION = Pathname(__dir__).join('..', '..', '.ruby-version').read.strip
  NODE_VERSION = "6.2.0"

  VERSION = "2.1.0"
end
