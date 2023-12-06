# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require './lib/api'

describe GAPI do
  include Rack::Test::Methods

  def app
    GAPI
  end

  describe 'test av V1' do
    it 'returner grunnbeloep json' do
      get '/api/v1/grunnbeloep'
      assert last_response.ok?
      assert_equal({ 'dato' => '2022-05-01', 'grunnbeloep' => 111_477, 'grunnbeloepPerMaaned' => 9_290,
                     'gjennomsnittPerAar' => 109_784, 'omregningsfaktor' => 1.047726,
                     'virkningstidspunktForMinsteinntekt' => '2022-05-23' },
                   JSON.parse(last_response.body))
    end

    it 'returner grunnbeloep json basert på dato' do
      get '/api/v1/grunnbeloep?dato=1997-04-30'
      assert last_response.ok?
      assert_equal({ 'dato' => '1996-05-01', 'grunnbeloep' => 41_000, 'grunnbeloepPerMaaned' => 3_417,
                     'gjennomsnittPerAar' => 40_410, 'omregningsfaktor' => 1.045119 },
                   JSON.parse(last_response.body))
    end

    it 'vi støtter norsk talemål å skrive dato på' do
      get '/api/v1/grunnbeloep?dato=24-08-2010'
      assert last_response.ok?
      assert_equal({ 'dato' => '1996-05-01', 'grunnbeloep' => 41_000, 'grunnbeloepPerMaaned' => 3_417,
                     'gjennomsnittPerAar' => 40_410, 'omregningsfaktor' => 1.045119 },
                   JSON.parse(last_response.body))
    end

    it 'returnerer all historikk for grunnbeløp' do
      get '/api/v1/historikk'
      assert last_response.ok?
      assert_equal 7, JSON.parse(last_response.body).size
    end

    it 'returnerer historikk fra og med dato' do
      get '/api/v1/historikk?fra=2019-04-30'
      assert last_response.ok?
      assert_equal 3, JSON.parse(last_response.body).size
    end
  end
end
