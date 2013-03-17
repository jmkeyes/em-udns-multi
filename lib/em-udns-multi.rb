require 'em-udns'

module EventMachine::Udns
  class Multi
    include EventMachine::Deferrable

    VERSION = "0.0.1"

    def initialize
      @responses, @resolver = {}, EventMachine::Udns::Resolver.new
      EventMachine.next_tick { EventMachine::Udns.run @resolver }
    end

    def query(name, target, type = 'A')
      raise "EM::Udns doesn't know about #{type} records!" unless known_record_type?(type)

      on_any_response = proc { |result| @responses[name] = result; update_progress! }

      @resolver.send("submit_#{type}", target).tap do |this|
        this.callback(&on_any_response)
        this.errback(&on_any_response)
      end
    end

    def finished?
      @resolver.active == 0
    end

    private
    def known_record_type?(type)
      @resolver.respond_to?("submit_#{type}")
    end

    def update_progress!
      succeed(@responses) if finished?
    end
  end
end
