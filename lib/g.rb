# frozen_string_literal: true

require 'date'
require 'json'

module Grunnbeløp
  @grunnbeløp_data = JSON.parse(File.read('./grunnbeløp.json'), object_class: OpenStruct)
  @date_format = '%Y.%m.%d'

  def self.get_by_date(needle)
    datoer = @grunnbeløp_data.grunnbeløp.map { |obj| DateTime.strptime(obj.dato, @date_format) }
    found = datoer
              .select { |date| date <= needle.to_datetime }
              .min_by { |date| (date.to_time - needle.to_time).abs }
              .strftime(@date_format)
    @grunnbeløp_data['grunnbeløp'].select { |obj| obj.dato == found }.first
  end

  def self.parse_needle(needle)
    return DateTime.now unless needle

    Date.parse(needle)
  end

  def self.get(needle = nil)
    begin
      needle = parse_needle(needle)
    rescue Date::Error
      return { status: 400, message: 'invalid date' }
    end

    grunnbeløp = get_by_date(needle)
    grunnbeløp.to_h
  end
end
