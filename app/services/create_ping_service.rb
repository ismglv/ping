# frozen_string_literal: true

class CreatePingService
  PING_TIMEOUT = 10

  def call(ip)
    ping = Net::Ping::External.new(ip.host, ip.port, PING_TIMEOUT)

    ping.ping
    Ping.create(ip: ip, duration: ping.duration, exception: ping.exception)
  end
end
