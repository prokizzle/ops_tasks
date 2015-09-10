require 'figaro'
require 'dotenv'

module OpsTasks
  class CliHelper
    def self.detect_env
      return 'dotenv' if File.file?("#{Dir.pwd}/.env")
      return 'figaro' if File.file?("#{Dir.pwd}/config/application.yml")
    end

    def self.load_env
      Dotenv.load if detect_env == 'dotenv'
      load_figaro if detect_env == 'figaro'
    end

    def self.load_figaro
      Figaro.application = Figaro::Application.new(
        environment: "production",
        path: "#{Dir.pwd}/config/application.yml"
      )
      Figaro.load
    end
  end
end
