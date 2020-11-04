# frozen_string_literal: true

class PingerWithHash
  MAX_THREADS = 10
  SLEEP_TIMER = 1

  def perform
    pinger_threads = {}

    loop do
      Ip.active.find_in_batches do |ips|
        ips.each do |ip|
          pinger_thread = pinger_threads[ip.id]

          next if pinger_thread&.alive?

          while Thread.list.count > MAX_THREADS do
            sleep 1
          end
          pinger_logger.info("RECREATE THREAD #{ip.host}")
          pinger_threads[ip.id] = Thread.new { CreatePingService.new.call(ip) }
        end
      end
    end
  end

  private

  def pinger_logger
    @pinger_logger = Logger.new('log/pinger.log')
  end
end
