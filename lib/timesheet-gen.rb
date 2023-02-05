# frozen_string_literal: true

require 'axlsx'
require 'yaml'

module TimesheetGen
  autoload :Builder, 'timesheet-gen/builder'
  autoload :DateRange, 'timesheet-gen/date_range'
  autoload :Day, 'timesheet-gen/dat'
  autoload :Harvest, 'timesheet-gen/harvest'
  autoload :Holidays, 'timesheet-gen/holidays'

  CONFIG_CANDIDATES = %w[ ~./timesheet-gen.rc ./config/timesheet-gen.yml ].freeze

  def self.resolve_config
    config_file = [ENV['CONFIG'], *CONFIG_CANDIDATES].compact.find { |f| File.exist?(f) }
    YAML.load_file(config_file) if config_file
  end
end
