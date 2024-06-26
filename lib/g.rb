# frozen_string_literal: true

require 'date'
require 'grape'
require 'grape-swagger-entity'
require 'json'

class Grunnbeløp < Grape::Entity
  expose :dato, documentation: { type: Date, desc: 'Dato for grunnbeløpet' }
  expose :grunnbeløp, documentation: { type: Integer, desc: 'Grunnbeløpet' }
  expose :grunnbeløp_per_måned, documentation: { type: Integer, desc: 'Grunnbeløpet per måned' }
  expose :gjennomsnitt_per_år, documentation: { type: Integer, desc: 'Gjennomsnitt per år' }
  expose :omregningsfaktor, documentation: { type: Float, desc: 'Omregningsfaktor' }
  expose :virkningstidspunkt_for_minsteinntekt, documentation: { type: Date,
                                                                 desc: 'Virkningstidspunkt for minsteinntekt' }
end

class Grunnbeloep < Grape::Entity
  expose :dato, documentation: { type: Date, desc: 'Dato for grunnbeloepet' }
  expose :grunnbeloep, documentation: { type: Integer, desc: 'Grunnbeloepet' }
  expose :grunnbeloep_per_maaned, documentation: { type: Integer, desc: 'Grunnbeloepet per maaned' }
  expose :gjennomsnitt_per_aar, documentation: { type: Integer, desc: 'Gjennomsnitt per aar' }
  expose :omregningsfaktor, documentation: { type: Float, desc: 'Omregningsfaktor' }
  expose :virkningstidspunkt_for_minsteinntekt, documentation: { type: Date,
                                                                 desc: 'Virkningstidspunkt for minsteinntekt' }
end

module G
  @data = JSON.parse(File.read(ENV.fetch('GRUNNBELOP', './grunnbeløp.json')), object_class: Hash)
  @date_format = '%Y-%m-%d'

  def self.by_date(needle)
    datoer = @data.map { |obj| DateTime.strptime(obj['dato'], @date_format) }
    found = datoer
              .select { |date| date <= needle.to_datetime }
              .min_by { |date| (date.to_time - needle.to_time).abs }
              .strftime(@date_format)
    @data.select { |obj| obj['dato'] == found }.first
  end

  def self.today
    by_date(Date.today)
  end

  def self.from_date(needle)
    found = by_date(needle)

    @data.select { |obj| obj['dato'] >= found['dato'] }
  end

  def self.all_history
    @data
  end
end
