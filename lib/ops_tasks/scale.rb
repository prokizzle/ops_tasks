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

    def assess_status(instance_id)
      @client.describe_instances(
        :instance_ids => [instance_id]
      )[:instances].first[:status]
    end

    def wait_for_completion(instance_id, task="create instance")
      print "#{@project}: Running... "
      announce_status(task, wait_for_completion)
      poll_api_for_status(wait_for_completion)
      announce_status(task, wait_for_completion)
      announce_log(wait_for_completion) if deployment_failed?(wait_for_completion)
      Process.daemon if @run_in_background
    end
  end
end
