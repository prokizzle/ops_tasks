module OpsTasks
  require 'ops_tasks/railtie' if defined?(Rails)
  require 'ops_tasks/deployment'
  require 'ops_tasks/rake_helper'
  require 'ops_tasks/cli_helper'
  require 'ops_tasks/version'
end
