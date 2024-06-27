# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/e'

describe E do
  describe 'når noen ber om engangsstønad' do
    it 'skal du får siste verdi' do
      _(E.by_date(DateTime.now)['verdi']).must_equal 92_648
    end
  end

  describe 'når noen ber om engangsstønad for en spesifikk dato' do
    it 'skal du få riktig engangsstønad' do
      _(E.by_date(DateTime.new(2019, 5, 1))['verdi']).must_equal 83_140
    end

    it 'engangsstønad har en fra og med, og til og med dato' do
      _(E.by_date(DateTime.new(2020, 1, 1))['verdi']).must_equal 84_720
      _(E.by_date(DateTime.new(2020, 12, 31))['verdi']).must_equal 84_720
    end

    it 'fremtidige datoer er også akseptabelt' do
      _(E.by_date(DateTime.new(2120, 5, 1))['verdi']).must_equal 92_648
    end
  end
end
