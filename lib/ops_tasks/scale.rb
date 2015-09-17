module OpsTasks
  class Scale < OpsTasks::Deployment
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
      announce_status(task, deployment_id)
      poll_api_for_status(deployment_id)
      announce_status(task, deployment_id)
      announce_log(deployment_id) if deployment_failed?(deployment_id)
      Process.daemon if @run_in_background
    end
  end
end
