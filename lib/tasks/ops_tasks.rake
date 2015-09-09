# desc "Explaining what the task does"
# task :aws_deployment_tasks do
#   # Task goes here
# end

namespace :ops_tasks do
  desc "deploy with chef recipe"
  task :deploy => :environment do |t, args|
    deployment = OpsTasks::RakeHelper.create_deployment
    deploy_id = deployment.deploy
    deployment.wait_for_completion(deploy_id)
  end

  desc "update custom cookbooks"
  task :update_cookbooks => :environment do
    deployment = OpsTasks::RakeHelper.create_deployment
    deploy_id = deployment.update_cookbooks
    deployment.wait_for_completion(deploy_id, "update cookbooks")
  end

  desc "run setup recipe"
  task :setup => :environment do
    deployment = OpsTasks::RakeHelper.create_deployment
    deploy_id = deployment.setup
    deployment.wait_for_completion(deploy_id, "setup")
  end

  desc "run config recipe"
  task :configure => :environment do
    deployment = OpsTasks::RakeHelper.create_deployment
    deploy_id = deployment.configure
    deployment.wait_for_completion(deploy_id, "configure")
  end
end
