# frozen_string_literal: true

module TimesheetGen
  class Day < Struct.new(:date, :time_entries, :holiday, keyword_init: true)
    def hours
      time_entries&.sum(&:hours) || 0
    end

    def notes
      holiday&.summary
    end
  end
end
