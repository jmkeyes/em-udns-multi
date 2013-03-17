# EventMachine::Udns::Multi

Aggregate a large number of asynchronous DNS queries together using `em-udns`.

## Installation

Add this line to your application's Gemfile:

    gem 'em-udns-multi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install em-udns-multi

## Usage

The following example is trivial but can be expanded on significantly.

    #!/usr/bin/env ruby

    require 'eventmachine'
    require 'em-udns'
    require 'em-udns-multi'

    EventMachine.run do
      resolver = EventMachine::Udns::Multi.new

      resolver.callback do |results|
        puts "[x] Got a response: #{results.inspect}"
        EventMachine.stop
      end

      resolver.query('key', 'A', 'google.com')
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
