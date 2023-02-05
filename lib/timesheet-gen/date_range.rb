# frozen_string_literal: true

require 'date'

module TimesheetGen
  class DateRange
    include Enumerable

    attr_reader :context, :from, :to

    def initialize(context:, from:, to:)
      @context = context
      @from, @to = from, to
    end

    def each
      to_range.each do |date|
        yield Day.new(
                date:         date,
                time_entries: time_entries_by_day[date],
                holiday:      holidays_by_day[date]&.first
              )
      end
    end

    def to_range
      from..to
    end

    private

    def holidays_by_day
      @holidays_by_day ||= holidays.group_by { |e| e.dtstart.to_date }
    end

    def holidays
      @holidays ||= context.holidays[to_range]
    end

    def time_entries_by_day
      @time_entries_by_day ||= time_entries.group_by { |t| ::Date.parse(t.spent_date) }
    end

    def time_entries
      @time_entries ||= context.harvest[to_range]
    end
  end
end
