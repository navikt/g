# frozen_string_literal: true

require 'date'
require 'json'

module Grunnbeløp
  @grunnbeløp_data = JSON.parse(File.read('./grunnbeløp.json'), object_class: OpenStruct)
  @date_format = '%Y.%m.%d'

  def self.get_by_date(needle)
    datoer = @grunnbeløp_data.grunnbeløp.map { |obj| DateTime.strptime(obj.dato, @date_format) }
    found = datoer.min_by { |date| (date.to_time - needle.to_time).abs }
    found = found.strftime(@date_format)
    @grunnbeløp_data['grunnbeløp'].select { |obj| obj.dato == found }.first
  end

  def self.get(needle = nil)
    needle ||= Time.now
    grunnbeløp = get_by_date(needle)
    grunnbeløp.to_h
  end
end
