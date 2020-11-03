# frozen_string_literal: true

require 'spec_helper'

describe Acme::API do
  include Rack::Test::Methods

  def app
    Acme::API
  end

  describe 'GET /api/ping' do
    let!(:ip) { create :ip, host: '8.8.8.8' }
    before do
      create :ping, ip: ip, duration: 0.10, created_at: '2020-11-03 19:11:50'
      create :ping, ip: ip, duration: 0.20, created_at: '2020-11-03 17:11:50'
      create :ping, ip: ip, duration: nil, created_at: '2020-11-03 18:11:50'
    end

    let(:expected_stats) do
      {
        'avg_rtt' => 0.05,
        'max_rtt' => 0.1,
        'min_rtt' => 0.1,
        'median_rtt' => 0.1,
        'mean_square' => 0.1,
        'fail_percent' => 0.5
      }
    end

    it 'returns stats for given interval' do
      get '/api/ping', { host: '8.8.8.8', from: '2020-11-03 18:11:50', to: '2020-11-03 19:11:50' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(expected_stats)
    end

    it 'returns not found' do
      get '/api/ping', { host: '8.8.8.8', from: '1020-11-03 18:11:50', to: '1020-11-03 19:11:50' }
      expect(last_response.status).to eq(404)
    end
  end
end
