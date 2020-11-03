# frozen_string_literal: true

FactoryBot.define do
  factory :ping do
    ip
    duration { 0.05 }
  end
end
