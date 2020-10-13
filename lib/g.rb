require 'date'
require 'json'

module Grunnbeløp
  @@grunnbeløp_data = JSON.parse(File.read('./grunnbeløp.json'), object_class: OpenStruct)

  def self.get_grunnbeløp(needle=nil)
    needle ||= Time.now
    datoer = @@grunnbeløp_data.grunnbeløp.map {|obj| DateTime.strptime(obj.dato, '%Y.%m.%d')}
    found = datoer.sort_by { |date| (date.to_time - needle.to_time).abs }.first
    found = found.strftime('%Y.%m.%d')
    grunnbeløp = @@grunnbeløp_data['grunnbeløp'].select {|obj| obj.dato == found }.first
    return grunnbeløp.to_h
  end
end
