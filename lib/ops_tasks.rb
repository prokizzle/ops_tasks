require 'aws'
require 'hipchat'

module OpsTasks
  require 'ops_tasks/railtie' if defined?(Rails)
  class Deployment
    def initialize(args)
      if args.size > 0
        @client = AWS::OpsWorks::Client.new
        @instance_ids = [args[:id]]
        @recipe = args[:recipe]
        @stack_id = args[:stack_id]
        @notify = HipChat::Client.new(ENV['HIPCHAT_API_TOKEN'])
        @hipchat_room = args[:room]
        @project = args[:project]
      else
        puts "No args given"
        exit
      end
    end

    def deploy
      print "#{@project}: Preparing deployment... "
      id = @client.create_deployment(
        :stack_id => @stack_id,
        :instance_ids => @instance_ids,
        :command => {
          name: "execute_recipes",
          args: {"recipes" => [@recipe]}
        }
      )[:deployment_id]
      puts "successful"
      return id
    end

    def update_cookbooks
      print "#{@project}: Preparing cookbook update... "

      id = @client.create_deployment(
        :stack_id => @stack_id,
        :instance_ids => [@instance_id],
        :command => {name: 'update_custom_cookbooks'}
      )[:deployment_id]
      puts "successful"
      return id
    end


    def status(deployment_id)
      @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
    end

    def wait_for_completion(deployment_id, task="deployment")
      print "#{@project}: Running... "
      status = @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
      @notify[@hipchat_room].send('Chef', "#{@project} #{task} #{status}")
      until status != "running"
        status = @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
      end
      puts status
      @notify[@hipchat_room].send('Chef', "#{@project} #{task} #{status}")
    end

  end

  class Stack
  end
end
