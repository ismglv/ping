# frozen_string_literal: true

require 'spec_helper'

describe CreatePingStatsService do
  describe '#call' do
    subject(:stats_creator) { described_class.new(ip, from, to) }
    let(:ip) { create :ip, host: '8.8.8.8' }
    let(:from) { '2020-11-03 18:11:50' }
    let(:to) { '2020-11-03 19:11:50' }

    let(:expected_stats) do
      {
        avg_rtt: 0.05,
        max_rtt: 0.1,
        min_rtt: 0.1,
        median_rtt: 0.1,
        mean_square: 0.1,
        fail_percent: 0.5
      }
    end

    before do
      create :ping, ip: ip, duration: 0.10, created_at: '2020-11-03 19:11:50'
      create :ping, ip: ip, duration: 0.20, created_at: '2020-11-03 17:11:50'
      create :ping, ip: ip, duration: nil, created_at: '2020-11-03 18:11:50'
    end

    it 'returns ping stats' do
      result = stats_creator.call
      expect(result.success?).to eq true
      expect(result.value!).to eq expected_stats
    end

    context 'when no pings in interval' do
      let(:from) { '1020-11-03 18:11:50' }
      let(:to) { '1020-11-03 19:11:50' }

      it 'returns fail' do
        expect(stats_creator.call.failure?).to eq true
      end
    end
  end
end
