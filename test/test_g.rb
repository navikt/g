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

  describe 'når noen ber om grunnbeløp for en spesifikk dato' do
    it 'skal du få riktig grunnbeløp' do
      _(Grunnbeløp.get(DateTime.new(1977, 12, 1))[:grunnbeløp]).must_equal 14_400
    end

    it 'noen år har flere grunnbeløp' do
      _(Grunnbeløp.get(DateTime.new(1977, 2, 1))[:grunnbeløp]).must_equal 13_100
    end
  end
end
