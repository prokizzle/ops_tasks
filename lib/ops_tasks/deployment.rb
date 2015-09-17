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
      @run_in_background = args[:background]
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

    def setup
      print "#{@project}: Preparing setup... "
      id = @client.create_deployment(
        :stack_id => @stack_id,
        :instance_ids => instance_ids,
        :command => {
          name: "setup"
        }
      )[:deployment_id]
      puts "successful"
      return id
    end

    def configure
      print "#{@project}: Preparing configuration... "
      id = @client.create_deployment(
        :stack_id => @stack_id,
        :instance_ids => instance_ids,
        :command => {
          name: "configure"
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

    def log_url(deployment_id)
      @client.describe_commands(
        :deployment_ids => [deployment_id]
      )[:log_url]
    end


    def notifications_disabled?
      ENV["#{@project}_room_notifications"] == 'false'
    end

    # def status(deployment_id)
    #   @client.describe_deployments(:deployment_ids => [deployment_id])[:deployments].first[:status]
    # end

    def announce_status(task, deployment_id)
      return false if notifications_disabled?
      status = assess_status(deployment_id)
      "Chef".says("#{@project} #{task} #{status}").to_channel(@slack_channel)
    end

    def assess_status(deployment_id)
      @client.describe_deployments(
        :deployment_ids => [deployment_id]
      )[:deployments].first[:status]
    end

    def deployment_failed?(id)
      assess_status(id) == 'failed'
    end

    def announce_log(id)
      "Chef".
        says("<a href='#{log_url(id)}'>failure log</a>").
        to_channel(@slack_channel)
      puts log_url(id)
    end

    def poll_api_for_status(deployment_id)
      sleep 1 until assess_status(deployment_id) != "running"
      puts assess_status(deployment_id)
    end

    def wait_for_completion(deployment_id, task="deployment")
      print "#{@project}: Running... "
      announce_status(task, deployment_id)
      poll_api_for_status(deployment_id)
      announce_status(task, deployment_id)
      announce_log(deployment_id) if deployment_failed?(deployment_id)
      Process.daemon if @run_in_background
    end
  end
end
