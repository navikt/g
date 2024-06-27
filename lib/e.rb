# frozen_string_literal: true

require 'date'
require 'grape'
require 'grape-swagger-entity'
require 'json'

class Engangsstønad < Grape::Entity
  expose :fom, documentation: { type: Date, desc: 'Fra og med dato for engangsstønad' }
  expose :tom, documentation: { type: Date, desc: 'Til og med dato for engangsstønad' }
  expose :verdi, documentation: { type: Integer, desc: 'Satsen gjelder for fødsler og adopsjoner' }
end

class Engangsstoenad < Grape::Entity
  expose :fom, documentation: { type: Date, desc: 'Fra og med dato for engangsstoenad' }
  expose :tom, documentation: { type: Date, desc: 'Til og med dato for engangsstoenad' }
  expose :verdi, documentation: { type: Integer, desc: 'Satsen gjelder for foedsler og adopsjoner' }
end

module E
  @data = JSON.parse(File.read(ENV.fetch('ENGANGSSTØNAD', './engangsstønad.json')), object_class: Hash)
  @date_format = '%Y-%m-%d'

  def self.by_date(needle)
    datoer = @data.map { |obj| DateTime.strptime(obj['fom'], @date_format) }
    found = datoer
              .select { |date| date <= needle.to_datetime }
              .min_by { |date| (date.to_time - needle.to_time).abs }
              .strftime(@date_format)
    @data.select { |obj| obj['fom'] == found }.first
  end

  def self.today
    by_date(Date.today)
  end

  def self.from_date(needle)
    found = by_date(needle)

    @data.select { |obj| obj['fom'] >= found['fom'] }
  end

  def self.all_history
    @data
  end
end
