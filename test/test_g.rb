require 'minitest/autorun'
require 'minitest/pride'
require './lib/g.rb'

describe Grunnbeløp do
  before do
    # TODO: Mock-e ut datagrunnlaget
  end

  describe 'når noen ber om grunnbeløp' do
    it 'skal du får siste grunnbeløpet' do
      _(Grunnbeløp.get_grunnbeløp[:grunnbeløp]).must_equal 101351
    end
  end

  describe 'når noen ber om grunnbeløp for en spesifikk dato' do
    it 'skal du få riktig grunnbeløp' do
      _(Grunnbeløp.get_grunnbeløp(DateTime.new(1977,12,01))[:grunnbeløp]).must_equal 14400
    end

    it 'noen år har flere grunnbeløp' do
      _(Grunnbeløp.get_grunnbeløp(DateTime.new(1977,02,01))[:grunnbeløp]).must_equal 13100
    end
  end
end
