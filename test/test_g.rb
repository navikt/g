# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/g.rb'

describe Grunnbeløp do
  before do
    # TODO: Mock-e ut datagrunnlaget
  end

  describe 'når noen ber om grunnbeløp' do
    it 'skal du får siste grunnbeløpet' do
      _(Grunnbeløp.get(DateTime.now)[:grunnbeløp]).must_equal 101_351
    end
  end

  describe 'når noen ber om grunnbeløp for en spesifikk dato' do
    it 'skal du få riktig grunnbeløp' do
      _(Grunnbeløp.get(DateTime.new(2011, 5, 1))[:grunnbeløp]).must_equal 79_216
    end

    it 'noen år har flere grunnbeløp' do
      _(Grunnbeløp.get(DateTime.new(1977, 12, 31))[:grunnbeløp]).must_equal 14_400
      _(Grunnbeløp.get(DateTime.new(1977, 12, 1))[:grunnbeløp]).must_equal 14_400
      _(Grunnbeløp.get(DateTime.new(1977, 11, 30))[:grunnbeløp]).must_equal 13_400
      _(Grunnbeløp.get(DateTime.new(1977, 5, 1))[:grunnbeløp]).must_equal 13_400
      _(Grunnbeløp.get(DateTime.new(1977, 4, 30))[:grunnbeløp]).must_equal 13_100
      _(Grunnbeløp.get(DateTime.new(1977, 1, 1))[:grunnbeløp]).must_equal 13_100
    end

    it 'fremtidige datoer er også akseptabelt' do
      _(Grunnbeløp.get(DateTime.new(2120, 5, 1))[:grunnbeløp]).must_equal 101_351
    end
  end
end
