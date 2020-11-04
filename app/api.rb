# frozen_string_literal: true

class API < Grape::API
  prefix 'api'
  format :json
  mount ::Api::Ping
end
