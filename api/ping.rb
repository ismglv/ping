# frozen_string_literal: true

require 'pry'

module Acme
  class Ping < Grape::API
    format :json

    resource :ping do
      desc 'Return a status.'
      params do
        requires :host, type: String, desc: 'IP.'
        requires :from
        requires :to
      end
      get do
        ip = Ip.find_by!(host: params[:host])

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
        ip = Ip.find_by!(host: params[:host])
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
        ip = Ip.new(host: params[:host], port: params[:port] || 80)
        if ip.save
          ip.attributes
        else
          error!(ip.errors.full_messages, 422)
        end
      end
    end
  end
end
