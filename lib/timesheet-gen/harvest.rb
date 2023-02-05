# frozen_string_literal: true

require 'harvesting'

module TimesheetGen
  class Harvest
    def initialize(id:, token:)
      @id, @token = id, token
    end

    def client
      @client ||= Harvesting::Client.new(account_id: @id, access_token: @token)
    end

    def [](date_range)
      client.time_entries(user_id: client.me.id, from: date_range.first, to: date_range.last)
    end
  end
end
