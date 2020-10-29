# frozen_string_literal: true

require 'date'
require 'json'

module Grunnbeløp
  @grunnbeløp_data = JSON.parse(File.read('./grunnbeløp.json'), object_class: OpenStruct)
  @date_format = '%Y-%m-%d'

  def self.by_date(needle)
    datoer = @grunnbeløp_data.grunnbeløp.map { |obj| DateTime.strptime(obj.dato, @date_format) }
    found = datoer
              .select { |date| date <= needle.to_datetime }
              .min_by { |date| (date.to_time - needle.to_time).abs }
              .strftime(@date_format)

    @grunnbeløp_data['grunnbeløp'].select { |obj| obj.dato == found }.first.to_h
  end
end
