# frozen_string_literal: true

class PingerWorker
  include Sidekiq::Worker

  def perform
    pinger_threads = {}

    loop do
      sleep 5
      Ip.active.each do |ip|
        pinger_thread = pinger_threads[ip.id]

        next if pinger_thread.present? && pinger_thread.status

        puts "RECREATE THREAD #{ip.host}"
        pinger_threads[ip.id] = Thread.new { CreatePingService.new.call(ip) }
      end
    end
  end
end
