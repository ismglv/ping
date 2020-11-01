# frozen_string_literal: true

module Acme
  class App
    def initialize
      @rack_static = ::Rack::Static.new(
        -> { [404, {}, []] },
        urls: ['/']
      )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Acme::App.new
      end.to_app
    end

    def call(env)
      # api
      response = Acme::API.call(env)

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        content =  @rack_static.call(env)
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end
end
