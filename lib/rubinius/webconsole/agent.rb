require "json"
require "rubinius/agent"

module Rubinius
  module Webconsole
    class Agent
      attr_reader :pid, :port, :command, :path

      extend Forwardable
      def_delegator :@rbx_agent, :get

      def initialize(pid, port, cmd, path)
        @pid = pid
        @port = port
        @command = cmd
        @path = path
        @rbx_agent = nil
      end

      def connect(notice = true)
        @rbx_agent = Rubinius::Agent.connect "localhost", @port do
          Readline.readline("password> ")
        end

        if notice
          puts "Connected to localhost:#{@port}, host type: #{@rbx_agent.handshake[1]}"
        end

        self
      end

      def to_json
        {
          pid: @pid,
          port: @port,
          cmd: @command,
          path: @path
        }.to_json
      end
    end
  end
end
