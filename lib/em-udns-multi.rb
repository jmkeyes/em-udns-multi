require 'em-udns'

module EventMachine::Udns
  class Multi
    include EventMachine::Deferrable

    VERSION = "0.0.1"

    def initialize(timeout = nil)
      @responses, @pending = {}, []

      EventMachine.next_tick do
        # Initialize the resolver.
        EventMachine::Udns.run(resolver)

        # Since udns's timeout is private, use our own.
        on_timeout = proc { cancel_pending_queries! }
        EventMachine::Timer.new(timeout, &on_timeout) if timeout
      end
    end

    def query(name, target, type = 'A')
      raise "EM::Udns doesn't know about #{type} records!" unless known_record_type?(type)

      # When a result comes in, add it to the list or results.
      on_any_response = proc { |result| update_progress!(name, result) }

      # Add this query to the list of pending ones, so the timer can cancel them if necessary.
      @pending << @resolver.send("submit_#{type}", target).tap do |this|
        this.callback(&on_any_response)
        this.errback(&on_any_response)
      end
    end

    def finished?
      resolver.active == 0
    end

    private
    def resolver
      @resolver ||= EventMachine::Udns::Resolver.new
    end

    def known_record_type?(type)
      resolver.respond_to?("submit_#{type}")
    end

    def update_progress!(name, result = nil)
      @responses[name] = result
      succeed(@responses) if finished?
    end

    def cancel_pending_queries!
      @pending.each { |query| resolver.cancel(query) }
    end
  end
end
