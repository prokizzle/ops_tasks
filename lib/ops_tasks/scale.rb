module OpsTasks
  class Scale < OpsTasks::Deployment
    def initialize(args)
      @instance_type = args[:instance_type]
      super
    end

    def create_instance
      @client.create_instance(
        :stack_id => @stack_id,
        :layer_ids => [@layer_id],
        :instance_type => @instance_type
      )[:instance_id]
    end

    def start_instance(instance_id)
      @client.start_instance(
        :instance_id => instance_id
      )
    end

    def assess_status(instance_id)
      @client.describe_instances(
        :instance_ids => [instance_id]
      )[:instances].first[:status]
    end

    def deployment_failed?(instance_id)
      @client.describe_instances(
        :instance_ids => [instance_id]
      )[:instances].first[:status] == 'failed'
    end

    def poll_api_for_status(deployment_id)
      sleep 1 until assess_status(deployment_id) == 'online'
      puts assess_status(deployment_id)
    end

    def wait_for_completion(instance_id, task="create instance")
      print "#{@project}: Running... "
      announce_status(task, instance_id)
      poll_api_for_status(instance_id)
      announce_status(task, instance_id)
      announce_log(instance_id) if deployment_failed?(instance_id)
      Process.daemon if @run_in_background
    end
  end
end
