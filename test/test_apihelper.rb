# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require './lib/apihelper'

describe APIHelper do
  include APIHelper

  describe 'norske bokstaver skal bli normalisert' do
    it 'normalisere æøå' do
      _(normalize_norwegian_letters('hello æøå')).must_equal 'hello aeoeaa'
    end

    it 'normalisere ÆØÅ' do
      _(normalize_norwegian_letters('hello ÆØÅ')).must_equal 'hello AeOeAa'
    end

    it 'normalisere æøåÆØÅ' do
      _(normalize_norwegian_letters('hello æøåÆØÅ')).must_equal 'hello aeoeaaAeOeAa'
    end
  end
end
