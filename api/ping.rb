# frozen_string_literal: true

module Api
  class Ping < Grape::API
    format :json

    resource :ping do
      desc 'Return a stats.'
      params do
        requires :host, type: String, desc: 'IP.'
        optional :port, type: String, desc: 'port'
        requires :from
        requires :to
      end
      get do
        ip = Ip.find_by!(host: params[:host], port: params[:port] || 80)

        result = CreatePingStatsService.new(ip, params[:from], params[:to]).call
        if result.success?
          result.value!
        else
          error!('Not found', 404)
        end
      end

      desc 'Delets ping.'
      params do
        requires :host, type: String, desc: 'IP.'
      end
      delete do
        ip = Ip.find_by!(host: params[:host], port: params[:port] || 80)

        if ip.update(deleted_at: Time.now.utc)
          body false
        else
          error!('Unable to delete', 422)
        end
      end

      params do
        requires :host, type: String, desc: 'IP.'
        optional :port, type: String, desc: 'Port.'
      end
      desc 'Creates ping.'
      post do
        result = AddIpService.new(params).call
        if result.success?
          result.value!.attributes
        else
          error!(result.failure, 422)
        end
      end
    end
  end
end
