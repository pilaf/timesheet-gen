# frozen_string_literal: true

require 'icalendar'
require 'open-uri'

module TimesheetGen
  class Holidays
    # NOTE: literal %'s are escaped as %% as this is used as a sprintf template
    GOOGLE_CALENDAR_URI = 'https://calendar.google.com/calendar/u/0/ical/%{calendar}%%23holiday%%40group.v.calendar.google.com/public/basic.ics'

    def initialize(calendar:)
      @calendar = calendar
    end

    def uri
      GOOGLE_CALENDAR_URI % { calendar: @calendar }
    end

    def raw_ics
      @raw_ics ||= fetch
    end

    def icalendar
      @icalendar ||= Icalendar::Calendar.parse(raw_ics)
    end

    def events
      @events ||= icalendar.first.events.sort_by(&:dtstart)
    end

    def [](date_range)
      events.select { |e| date_range.include?(e.dtstart.to_date) }
    end

    private

    def fetch
      URI.open(uri)
    end
  end
end
