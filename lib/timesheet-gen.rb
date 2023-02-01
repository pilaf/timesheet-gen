# frozen_string_literal: true

require 'harvesting'
require 'axlsx'
require 'yaml'
require 'icalendar'
require 'open-uri'

module TimesheetGen
  CONFIG_CANDIDATES = %w[ ~./timesheet-gen.rc ./config/timesheet-gen.yml ].freeze

  def self.resolve_config
    config_file = [ENV['CONFIG'], *CONFIG_CANDIDATES].compact.find { |f| File.exist?(f) }
    YAML.load_file(config_file) if config_file
  end

  class Holidays
    # NOTE: literal %'s are escaped as %% as this is used as a sprintf template
    GOOGLE_CALENDAR_URI = 'https://calendar.google.com/calendar/u/0/ical/%{calendar}%%23holiday%%40group.v.calendar.google.com/public/basic.ics'

    def initialize(calendar)
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

    private

    def fetch
      URI.open(uri)
    end
  end
end
