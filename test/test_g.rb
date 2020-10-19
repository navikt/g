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
      _(Grunnbeløp.get[:grunnbeløp]).must_equal 101_351
    end
  end

  describe 'vi støtter forskjellige type dato-strenger' do
    it 'norsk dato' do
      _(Grunnbeløp.get('4.5.2011')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('04.05.2011')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('4-5-2011')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('04-05-2011')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('4/5/2011')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('04/05/2011')[:grunnbeløp]).must_equal 79_216
    end

    it 'ISO 8601' do
      _(Grunnbeløp.get('2011.5.17')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('2011.05.17')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('2011-5-17')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('2011-05-17')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('2011/5/17')[:grunnbeløp]).must_equal 79_216
      _(Grunnbeløp.get('2011/05/17')[:grunnbeløp]).must_equal 79_216
    end

    it 'feilmelding ved ugyldig dato' do
      _(Grunnbeløp.get('1988.11.31')[:status]).must_equal 400
    end
  end

  describe 'når noen ber om grunnbeløp for en spesifikk dato' do
    it 'skal du få riktig grunnbeløp' do
      _(Grunnbeløp.get('2011.5.1')[:grunnbeløp]).must_equal 79_216
    end

    it 'noen år har flere grunnbeløp' do
      _(Grunnbeløp.get('1977.12.31')[:grunnbeløp]).must_equal 14_400
      _(Grunnbeløp.get('1977.12.1')[:grunnbeløp]).must_equal 14_400
      _(Grunnbeløp.get('1977.11.30')[:grunnbeløp]).must_equal 13_400
      _(Grunnbeløp.get('1977.5.1')[:grunnbeløp]).must_equal 13_400
      _(Grunnbeløp.get('1977.4.30')[:grunnbeløp]).must_equal 13_100
      _(Grunnbeløp.get('1977.1.1')[:grunnbeløp]).must_equal 13_100
    end

    it 'fremtidige datoer er også akseptabelt' do
      _(Grunnbeløp.get('2120.5.1')[:grunnbeløp]).must_equal 101_351
    end
  end
end
