# frozen_string_literal: true

class AddIpService
  include Dry::Monads[:result]
  attr_reader :host, :port

  def initialize(args)
    @host = args[:host]
    @port = args[:port] || 80
  end

  def call
    ip = Ip.find_or_initialize_by(host: host, port: port)
    ip.deleted_at = nil

    if ip.save
      Success(ip)
    else
      Failure(ip.errors.full_messages)
    end
  end
end
