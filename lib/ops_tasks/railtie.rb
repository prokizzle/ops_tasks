require 'ops_tasks'
require 'rails'
module OpsTasks
  class Railtie < Rails::Railtie
    railtie_name :ops_tasks

    rake_tasks do
      load "tasks/ops_tasks.rake"
    end
  end
end