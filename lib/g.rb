# frozen_string_literal: true

require 'date'
require 'json'

module Grunnbeløp
  p ENV
  @grunnbeløp_data = JSON.parse(File.read(ENV['GRUNNBELØP']), object_class: Hash)
  @date_format = '%Y-%m-%d'

  def self.by_date(needle)
    datoer = @grunnbeløp_data['grunnbeløp'].map { |obj| DateTime.strptime(obj['dato'], @date_format) }
    found = datoer
              .select { |date| date <= needle.to_datetime }
              .min_by { |date| (date.to_time - needle.to_time).abs }
              .strftime(@date_format)
    @grunnbeløp_data['grunnbeløp'].select { |obj| obj['dato'] == found }.first
  end

  def self.today
    by_date(Date.today)
  end

  def self.from_date(needle)
    found = by_date(needle)

    @grunnbeløp_data['grunnbeløp'].select { |obj| obj['dato'] >= found['dato'] }
  end

  def self.all_history
    @grunnbeløp_data['grunnbeløp']
  end
end
