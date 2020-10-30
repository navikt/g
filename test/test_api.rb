# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require './lib/api'

describe G do
  include Rack::Test::Methods

  def app
    G
  end

  describe 'test av V1' do
    it 'returner grunnbeloep json' do
      get '/api/v1/grunnbeloep'
      assert last_response.ok?
      assert_equal({ 'dato' => '2020-05-01', 'grunnbeloep' => 101_351, 'grunnbeloepPerMaaned' => 8_446,
                     'gjennomsnittPerAar' => 100_853, 'omregningsfaktor' => 1.014951 },
                   JSON.parse(last_response.body))
    end

    it 'returner grunnbeloep json basert på dato' do
      get '/api/v1/grunnbeloep?dato=1997-04-30'
      assert last_response.ok?
      assert_equal({ 'dato' => '1996-05-01', 'grunnbeloep' => 41_000, 'grunnbeloepPerMaaned' => 3_417,
                     'gjennomsnittPerAar' => 40_410, 'omregningsfaktor' => 1.045119 },
                   JSON.parse(last_response.body))
    end

    it 'returnere feilkode ved ugyldige datoer' do
      get '/api/v1/grunnbeloep?dato=24-08-2010'
      assert_equal 400, last_response.status
      assert_equal 'dato is invalid', JSON.parse(last_response.body)['error']
    end
  end
end
