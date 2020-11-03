# frozen_string_literal: true

require 'spec_helper'

describe CreatePingService do
  describe '#call' do
    subject(:pinger) { described_class.new }
    let(:ip) { create :ip, host: '8.8.8.8' }

    it 'creates ping' do
      expect { pinger.call(ip) }.to change { Ping.count }.by(1)
    end
  end
end
