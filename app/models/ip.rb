# frozen_string_literal: true

class Ip < ActiveRecord::Base
  has_many :pings

  validates :host, :port, presence: true

  scope :active, -> { where(deleted_at: nil) }
end
