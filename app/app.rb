# frozen_string_literal: true

class App
  def self.instance
    @instance ||= Rack::Builder.new do
      run ::App.new
    end.to_app
  end

  def call(env)
    ::API.call(env)
  end
end
