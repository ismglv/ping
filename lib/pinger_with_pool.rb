# frozen_string_literal: true

class PingerWithPool
  MAX_THREADS = 10

  def perform
    loop do
      Ip.active.find_in_batches do |ips|
        ips.each do |ip|
          pinger_logger.info "#{ip.host} added to queue"
          pool.post { CreatePingService.new.call(ip) }
        end
      end
    end
  end

  private

  def pool
    @pool ||= Concurrent::ThreadPoolExecutor.new(
      min_threads: 5,
      max_threads: MAX_THREADS,
      max_queue: 100,
      fallback_policy: :caller_runs
    )
  end

  def pinger_logger
    @pinger_logger = Logger.new('log/pinger.log')
  end
end
