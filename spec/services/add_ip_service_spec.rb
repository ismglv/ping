# frozen_string_literal: true

require 'spec_helper'

describe AddIpService do
  describe '#call' do
    subject { described_class.new(params) }
    let(:params) { { host: host } }
    let(:host) { '8.8.8.8' }

    it 'creates ip' do
      result = subject.call
      expect(result.success?).to eq true
      expect(result.value!.host).to eq host
    end

    context 'when ip already exist' do
      before { create :ip, host: host }

      it 'does not create ip' do
        expect{ subject.call }.to change{ Ip.count }.by 0
      end
    end

    context 'when ip was deleted' do
      before { create :ip, host: host, deleted_at: Time.now.utc }

      it 'removes deleted_at' do
        expect(subject.call.value!.deleted_at).to eq nil
      end
    end
  end
end
