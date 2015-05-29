# desc "Explaining what the task does"
# task :aws_deployment_tasks do
#   # Task goes here
# end

namespace :ops_tasks do
  servers = ENV.keys.select{|k| k.match(/_stack/) && !k.match(/FIGARO/)}.map{|k| k.match(/(.+)_stack_id/)[1]}
  if servers.empty?
    puts "You haven't setup your layers in your environment variables"
    exit
  end
  say("\nSelect a server...")
  choose do |menu|
    servers.each do |server|
      menu.choice server do @server_type = server end
    end
    menu.choice "quit" do exit end
  end
  @deployment = OpsTasks::Deployment.new(
    layer_id: ENV["#{@server_type}_layer_id"],
    stack_id: ENV["#{@server_type}_stack_id"],
    recipe: ENV["#{@server_type}_deploy_recipe"],
    project: ENV["#{@server_type}_project_name"],
    room: ENV["#{@server_type}_slack_channel"]
  )
  task :deploy => :environment do |t, args|
    deploy_id = @deployment.deploy
    @deployment.wait_for_completion(deploy_id)
  end

  task :update_cookbooks => :environment do
    deploy_id = @deployment.update_cookbooks
    @deployment.wait_for_completion(deploy_id, "update cookbooks")
  end
end
