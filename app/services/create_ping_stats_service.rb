# frozen_string_literal: true

class CreatePingStatsService
  include Dry::Monads[:result]
  attr_reader :ip, :from, :to, :pings

  def initialize(ip, from, to)
    @ip = ip
    @from = from
    @to = to
    @pings = ip.pings.where(interval)
  end

  def call
    if pings.present?
      Success(stats)
    else
      Failure()
    end
  end

  private

  def interval
    "created_at >= '#{from}' and created_at <= '#{to}'"
  end

  def stats
    {
      avg_rtt: avg_rtt,
      max_rtt: max_rtt,
      min_rtt: min_rtt,
      median_rtt: median_rtt,
      standard_deviation: standard_deviation,
      fail_percent: fail_percent
    }
  end

  def avg_rtt
    succeeded_pings_duration.reduce(:+).to_f / pings.count.to_f
  end

  def max_rtt
    succeeded_pings_duration.max
  end

  def min_rtt
    succeeded_pings_duration.min
  end

  def median_rtt
    sorted = succeeded_pings_duration.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def mean_square_rtt
    Math.sqrt(succeeded_pings_duration.inject(0.0) { |s, y| s + y * y } / succeeded_pings_duration.length)
  end

  def standard_deviation
    mean = succeeded_pings_duration.inject(:+) / succeeded_pings_duration.length.to_f
    var_sum = succeeded_pings_duration.map{|n| (n-mean)**2}.inject(:+).to_f
    sample_variance = var_sum / (succeeded_pings_duration.length - 1)
    Math.sqrt(sample_variance)
  end

  def fail_percent
    failed_pings.count / pings.count.to_f
  end

  def succeeded_pings_duration
    @succeeded_pings ||= pings.where.not(duration: nil).pluck(:duration)
  end

  def failed_pings
    @failed_pings ||= pings.where(duration: nil)
  end
end
