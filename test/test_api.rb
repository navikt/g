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
    describe 'test av grunnbeløp' do
      it 'returner grunnbeloep json' do
        get '/api/v1/grunnbeloep'
        assert last_response.ok?

        expected = { 'dato' => '2022-05-01', 'grunnbeloep' => 111_477, 'grunnbeloepPerMaaned' => 9_290,
                     'gjennomsnittPerAar' => 109_784, 'omregningsfaktor' => 1.047726,
                     'virkningstidspunktForMinsteinntekt' => '2022-05-23' }
        assert_equal(expected, JSON.parse(last_response.body))
      end

      it 'returner grunnbeloep json basert på dato' do
        get '/api/v1/grunnbeloep?dato=1997-04-30'
        assert last_response.ok?

        expected = { 'dato' => '1996-05-01', 'grunnbeloep' => 41_000, 'grunnbeloepPerMaaned' => 3_417,
                     'gjennomsnittPerAar' => 40_410, 'omregningsfaktor' => 1.045119 }
        assert_equal(expected, JSON.parse(last_response.body))
      end

      it 'vi støtter norsk talemål å skrive dato på' do
        get '/api/v1/grunnbeloep?dato=24-08-2010'
        assert last_response.ok?

        expected = { 'dato' => '1996-05-01', 'grunnbeloep' => 41_000, 'grunnbeloepPerMaaned' => 3_417,
                     'gjennomsnittPerAar' => 40_410, 'omregningsfaktor' => 1.045119 }
        assert_equal(expected, JSON.parse(last_response.body))
      end
    end

    describe 'test av engangsstønad' do
      it 'returner engangsstoenad json' do
        get '/api/v1/engangsstoenad'
        assert last_response.ok?

        expected = { 'fom' => '2023-01-01', 'tom' => '2122-08-08', 'verdi' => 92_648 }
        assert_equal(expected, JSON.parse(last_response.body))
      end

      it 'returner engangsstoenad json basert på dato' do
        get '/api/v1/engangsstoenad?dato=2019-04-30'
        assert last_response.ok?

        expected = { 'fom' => '2019-01-01', 'tom' => '2019-12-31', 'verdi' => 83_140 }
        assert_equal(expected, JSON.parse(last_response.body))
      end

      it 'vi støtter norsk talemål å skrive dato på' do
        get '/api/v1/engangsstoenad?dato=24-08-2020'
        assert last_response.ok?

        expected = { 'fom' => '2020-01-01', 'tom' => '2020-12-31', 'verdi' => 84_720 }
        assert_equal(expected, JSON.parse(last_response.body))
      end
    end

    describe 'test av historikk' do
      it 'returnerer all historikk for grunnbeløp' do
        get '/api/v1/historikk/grunnbel%C3%B8p'
        assert last_response.ok?
        assert_equal 7, JSON.parse(last_response.body).size
      end

      it 'returnerer historikk for grunnbeløp fra og med dato' do
        get '/api/v1/historikk/grunnbel%C3%B8p?fra=2019-04-30'
        assert last_response.ok?
        assert_equal 3, JSON.parse(last_response.body).size
      end

      it 'returnerer all historikk for engangsstønad' do
        get '/api/v1/historikk/engangsst%C3%B8nad'
        assert last_response.ok?
        assert_equal 5, JSON.parse(last_response.body).size
      end

      it 'returnerer historikk for engangsstønad fra og med dato' do
        get '/api/v1/historikk/engangsst%C3%B8nad?fra=2019-04-30'
        assert last_response.ok?
        assert_equal 4, JSON.parse(last_response.body).size
      end
    end
  end
end
