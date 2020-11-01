# frozen_string_literal: true

class CreateIps < ActiveRecord::Migration[6.0]
  create_table :ips, force: :cascade do |t|
    t.string :host, null: false
    t.integer :port, default: 80

    t.datetime :deleted_at
    t.timestamps null: false
  end
end
