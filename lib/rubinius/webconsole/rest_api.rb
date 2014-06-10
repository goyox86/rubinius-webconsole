require "json"
require "sinatra"
require "rubinius/webconsole/agent_manager"

module Rubinius
  module Webconsole
    class RestApi < Sinatra::Base
      before do
        content_type :json
        @manager ||= Rubinius::Webconsole::AgentManager.new
        @manager.find_all
      end

      get "/agents" do
        @manager.agents.keys.to_json
      end

      get "/agents/:pid" do
        agent = @manager[params[:pid].to_i]

        agent.to_json if agent
      end

      get "/agents/:pid/jit" do
        agent = @manager[params[:pid].to_i]

        {
          jit: {
            "time" => agent.get("system.jit.time")[1],
            "global_serial" => agent.get("system.jit.global_serial")[1],
            "cache_resets" => agent.get("system.jit.cache_resets")[1],
            "methods" => agent.get("system.jit.methods")[1]
          }
        }.to_json
      end

      get "/agents/:pid/memory" do
        agent = @manager[params[:pid].to_i]

        {
          memory: {
            "symbols.bytes" => agent.get("system.memory.symbols.bytes")[1],
            "young.bytes" => agent.get("system.memory.young.bytes")[1],
            "large.bytes" => agent.get("system.memory.large.bytes")[1],
            "code.bytes" => agent.get("system.memory.code.bytes")[1],
            "mature.bytes" => agent.get("system.memory.mature.bytes")[1],
            "counter.mature_bytes" => agent.get("system.memory.counter.mature_bytes")[1],
            "counter.mature_objects" => agent.get("system.memory.counter.mature_objects")[1],
            "counter.young_bytes" => agent.get("system.memory.counter.young_bytes")[1],
            "counter.young_objects" => agent.get("system.memory.counter.young_objects")[1],
            "counter.promoted_bytes" => agent.get("system.memory.counter.promoted_bytes")[1],
            "counter.promoted_objects" => agent.get("system.memory.counter.promoted_objects")[1]
          }
        }.to_json
      end

      get "/agents/:pid/gc" do
        agent = @manager[params[:pid].to_i]

        {
          gc: {
            "full.total_concurrent_wallclock" => agent.get("system.gc.full.total_concurrent_wallclock")[1],
            "full.total_stop_wallclock" => agent.get("system.gc.full.total_stop_wallclock")[1],
            "full.last_concurrent_wallclock" => agent.get("system.gc.full.last_concurrent_wallclock")[1],
            "full.last_stop_wallclock" => agent.get("system.gc.full.last_stop_wallclock")[1],
            "full.count" => agent.get("system.gc.full.count")[1],
            "young.total_wallclock" => agent.get("system.gc.young.total_wallclock")[1],
            "young.last_wallclock" => agent.get("system.gc.young.last_wallclock")[1],
            "young.count" => agent.get("system.gc.young.count")[1]
          }
        }.to_json
      end

      get "/agents/:pid/threads" do
        agent = @manager[params[:pid].to_i]

        {
          threads: {
            "count" => agent.get("system.threads.count")[1],
            "backtrace" => agent.get("system.threads.backtrace")
          }
        }.to_json
      end

      get "/agents/:pid/backtrace" do
        agent = @manager[params[:pid].to_i]

        {
          backtrace: agent.get("system.backtrace")
        }.to_json
      end
    end
  end
end
