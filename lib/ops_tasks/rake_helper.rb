require 'highline/import'

module OpsTasks
  class RakeHelper
    def self.servers
      ENV.keys.select do |k|
        k.match(/_stack_id/) && !k.match(/FIGARO/)
      end.map{|k| k.match(/(.+)_stack_id/)[1]}
    end

    def self.check_for_env_vars
      if servers.empty?
        puts "You haven't setup your layers in your environment variables"
        exit
      end
    end

    def self.select_server_type
      check_for_env_vars
      if servers.size > 1
        @server_type = nil
        say("\nSelect a server...")
        show_menu(servers)
      else
        @server_type = servers.first
      end
      @server_type
    end

    def self.show_menu(servers)
      choose do |menu|
        servers.each do |server|
          menu.choice server do @server_type = server end
        end
        menu.choice "quit" do exit end
      end
    end

    def self.create_deployment
      server_type = select_server_type
      return OpsTasks::Deployment.new(
        layer_id: ENV["#{server_type}_layer_id"],
        stack_id: ENV["#{server_type}_stack_id"],
        recipe: ENV["#{server_type}_deploy_recipe"],
        project: ENV["#{server_type}_project_name"],
        room: ENV["#{server_type}_slack_channel"]
      )
    end
  end
end
