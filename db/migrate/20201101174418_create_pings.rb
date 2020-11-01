# frozen_string_literal: true

class CreatePings < ActiveRecord::Migration[6.0]
  create_table :pings, force: :cascade do |t|
    t.belongs_to :ip, null: false

    t.float :duration
    t.string :exception
    t.string :warning

    t.timestamps null: false
  end
end
