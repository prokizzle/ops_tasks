require 'say2slack'
require 'aws-sdk'

module OpsTasks
  class Deployment
    def initialize(args)
      @client = AWS::OpsWorks::Client.new
      @layer_id = args[:layer_id]
      @recipe = args[:recipe]
      @stack_id = args[:stack_id]
      @slack_channel = args[:room]
      @project = args[:project]
    end

    def instance_ids
      client = AWS::OpsWorks::Client.new
      instance_objects = client.describe_instances(:layer_id => @layer_id)
      return instance_objects.instances.map{|i| i.instance_id}.to_a
    end

    def deploy
      print "#{@project}: Preparing deployment... "
      id = @client.create_deployment(
        :stack_id => @stack_id,
        :instance_ids => instance_ids,
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
        :instance_ids => instance_ids,
        :command => {name: 'update_custom_cookbooks'}
      )[:deployment_id]
      puts "successful"
      return id
    end

    def notifications_disabled?
      ENV["#{@project}_room_notifications"] == 'false'
    end

    def status(deployment_id)
      @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
    end

    def wait_for_completion(deployment_id, task="deployment")
      print "#{@project}: Running... "
      status = @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
      "Chef".says("#{@project} #{task} #{status}").to_channel(@slack_channel) unless notifications_disabled?
      until status != "running"
        status = @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
      end
      puts status
      "Chef".says("#{@project} #{task} #{status}").to_channel(@slack_channel) unless notifications_disabled?
    end
  end
end
