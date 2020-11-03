# frozen_string_literal: true

FactoryBot.define do
  factory :ip do
    host { '8.8.8.8' }
    port { 80 }
  end
end
