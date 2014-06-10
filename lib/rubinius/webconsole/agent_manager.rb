require "forwardable"
require "json"
require "rubinius/webconsole/agent"


module Rubinius
  module Webconsole
    class AgentManager
      attr_reader :agents

      extend Forwardable
      def_delegator :@agents, :[]

      def initialize
        @agents = Hash.new
      end

      def find_all
        cleanup true

        unless dir = ENV['TMPDIR']
          dir = "/tmp"
          return [] unless File.directory?(dir) and File.readable?(dir)
        end

        agents = Dir["#{dir}/rubinius-agent.*"]

        return [] unless agents

        agents.map do |path|
          pid, port, cmd, exec = File.readlines(path)
          cmd = cmd.strip if cmd
          exec = exec.strip if exec
          agent = Agent.new(pid.to_i, port.to_i, cmd, exec)
          @agents[pid.to_i] = agent.connect
        end

        @agents
      end

      def cleanup(quiet = false)
        unless dir = ENV['TMPDIR']
          dir = "/tmp"
          return [] unless File.directory?(dir) and File.readable?(dir)
        end

        agents = Dir["#{dir}/rubinius-agent.*"]

        return [] unless agents

        agents.map do |path|
          pid, port, cmd, exec = File.readlines(path)
          `kill -0 #{pid.strip} 2>&1`
          if $?.exitstatus != 0
            puts "Removing #{path}" unless quiet
            File.unlink path
          end
        end
      end
    end
  end
end
