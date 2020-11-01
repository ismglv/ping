# frozen_string_literal: true

module Acme
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Acme::Ping
  end
end
