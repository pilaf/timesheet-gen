# frozen_string_literal: true

module TimesheetGen
  class Builder
    attr_reader :config

    def initialize(config: ::TimesheetGen.resolve_config)
      @config = config
    end

    def last_month
      @last_month ||=
        begin
          today = Date.today
          first_of_last_month = Date.civil(today.year, today.month, 1).prev_month
          month(first_of_last_month.year, first_of_last_month.month)
        end
    end

    def current_month
      @current_month ||= month(Date.today.year, Date.today.month)
    end

    def month(year, month)
      from = Date.civil(year, month, 1)
      DateRange.new(context: self, from: from, to: from.next_month.prev_day)
    end

    def harvest
      @harvest ||= Harvest.new(**config.fetch('harvest').transform_keys(&:to_sym))
    end

    def holidays
      @holidays ||= Holidays.new(**config.fetch('holidays').transform_keys(&:to_sym))
    end
  end
end
