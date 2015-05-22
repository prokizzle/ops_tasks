# desc "Explaining what the task does"
# task :aws_deployment_tasks do
#   # Task goes here
# end

desc "Deploy to staging"
namespace :staging do
  @staging_deployment = OpsTasks::Deployment.new(
    layer_id: ENV['staging_layer_id'],
    stack_id: ENV['staging_stack_id'],
    recipe: ENV['staging_deploy_recipe'],
    project: ENV['staging_project_name'],
    room: ENV['staging_slack_channel']
  )
  task :deploy => :environment do
    deploy_id = @staging_deployment.deploy
    @staging_deployment.wait_for_completion(deploy_id)
  end

  task :update_cookbooks => :environment do
    deploy_id = @staging_deployment.update_cookbooks
    @staging_deployment.wait_for_completion(deploy_id, "update cookbooks")
  end

end

namespace :production do
  @production_deployment = OpsTasks::Deployment.new(
    layer_id: ENV['production_layer_id'],
    stack_id: ENV['production_stack_id'],
    recipe: ENV['production_deploy_recipe'],
    project: ENV['production_project_name'],
    room: ENV['production_slack_channel']
  )

  task :deploy => :environment do
    deploy_id = @production_deployment.deploy
    @production_deployment.wait_for_completion(deploy_id)
  end

  task :update_cookbooks => :environment do
    deploy_id = @production_deployment.update_cookbooks
    @production_deployment.wait_for_completion(deploy_id, "update cookbooks")
  end
end

task :deploy => :environment do |t, args|
  server_type = ask("server type: ")
  @deployment = OpsTasks::Deployment.new(
    layer_id: ENV["#{server_type}_layer_id"],
    stack_id: ENV["#{server_type}_stack_id"],
    recipe: ENV["#{server_type}_deploy_recipe"],
    project: ENV["#{server_type}_project_name"],
    room: ENV["#{server_type}_slack_channel"]
  )
  deploy_id = @deployment.deploy
  @deployment.wait_for_completion(deploy_id)
end
