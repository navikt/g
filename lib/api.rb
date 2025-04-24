# frozen_string_literal: true

require 'date'
require 'grape'
require 'grape_logging'
require 'grape-swagger'
require 'grape-swagger-entity'
require 'rack/cors'

require_relative 'e'
require_relative 'g'
require_relative 'apihelper'

class GAPI < Grape::API
  include APIHelper

  logger.formatter = GrapeLogging::Formatters::Logstash.new
  insert_before Grape::Middleware::Error, GrapeLogging::Middleware::RequestLogger, { logger: }

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  content_type :txt, 'text/plain; charset=utf-8'
  content_type :json, 'application/json'

  desc 'Litt om API-et', hidden: true
  get do
    content_type 'text/html'

    g = G.today
    engangsstønad = E.today
    output = %(
<!DOCTYPE html>
<html lang="no">
  <head>
    <meta charset="utf-8">
    <title>API for grunnbeløp og engangsstønad</title>
  </head>
  <body role="main">
    <h1>G er en API-tjeneste som gir deg dagens grunnbeløp og engangsstønad</h1>

    <h2>Grunnbeløp</h2>
    <p>Grunnbeløpet (G) per #{g['dato']} er #{g['grunnbeløp']} kroner.</p>
    <p>API-et er dokumentert med Swagger, og du kan se dokumentasjonen på
    <a href="https://g.nav.no/api/v1/swagger_doc">https://g.nav.no/api/v1/swagger_doc</a>.</p>
    <p>Du finner også grunnbeløpet på
    <a href="https://www.nav.no/grunnbelopet">https://www.nav.no/grunnbelopet</a>.</p>

    <h2>Engangsstønad</h2>
    <p>Engangsstønaden fra og med #{engangsstønad['fom']} er #{engangsstønad['verdi']} kroner.</p>
    <p>API-et er dokumentert med Swagger, og du kan se dokumentasjonen på
    <a href="https://g.nav.no/api/v1/swagger_doc">https://g.nav.no/api/v1/swagger_doc</a>.</p>
    <p>Du finner også engangsstønaden på
    <a href="https://www.nav.no/engangsstonad">https://www.nav.no/engangsstonad</a>.</p>

    <h2>Om API-et</h2>
    <p>API-et er open source, og du finner kildekoden på <a href="https://github.com/navikt/g">https://github.com/navikt/g</a>.</p>
    <p>API-et er registrert i <a href="https://data.norge.no/dataservices/27f14a5e-762a-32d7-9cef-05f2e6939cc1">
    Felles datakatalog</a>.</p>
  </body>
</html>
)

    output
  end

  get :isAlive do
    G.today
  end

  version 'v1', using: :path
  format :json
  prefix :api

  helpers do
    params :grunnbeløp do
      optional :dato, type: Date
    end

    def logger
      GAPI.logger
    end
  end

  before do
    if request.path.start_with?('/api/v1/') && request&.location&.data
      logger.info("Request for #{request.path} from #{request.location.data['ip']}")
    end
  end

  desc 'Returnerer dagens grunnbeløp' do
    detail 'Man kan også søke opp andre grunnbeløp ved å spesifisere ?dato=<ISO 8601>'
    success model: Grunnbeløp
  end
  params do
    use :grunnbeløp
  end
  get :grunnbeløp do
    dato = params[:dato] || DateTime.now
    G.by_date(dato)
  end

  desc 'Returnerer dagens grunnbeloep' do
    detail 'Man kan ogsaa soeke opp andre grunnbeloep ved å spesifisere ?dato=<ISO 8601>'
    success model: Grunnbeloep
  end
  params do
    use :grunnbeløp
  end
  get :grunnbeloep do
    dato = params[:dato] || DateTime.now
    JSON.parse(APIHelper.normalize_norwegian_letters(G.by_date(dato).to_json))
  end

  desc 'Returnerer dagens engangsstønad' do
    detail 'Man kan også søke opp andre engangsstønader ved å spesifisere ?dato=<ISO 8601>'
    success model: Engangsstønad
  end
  params do
    use :grunnbeløp
  end
  get :engangsstønad do
    dato = params[:dato] || DateTime.now
    E.by_date(dato)
  end

  desc 'Returnerer dagens engangsstoenad' do
    detail 'Man kan også soeke opp andre engangsstoenader ved å spesifisere ?dato=<ISO 8601>'
    success model: Engangsstoenad
  end
  params do
    use :grunnbeløp
  end
  get :engangsstoenad do
    dato = params[:dato] || DateTime.now
    E.by_date(dato)
  end

  resource :historikk do
    desc 'Historikk over grunnbeløp og engangsstønad'

    desc 'Historikk over grunnbeløp' do
      detail 'Man kan få historikk fra og med en spesifikk dato ved å spesifisere ?fra=<ISO 8601>'
      success model: Grunnbeløp
      is_array true
    end
    params do
      optional :fra, type: Date
    end
    get :grunnbeløp do
      fra = params[:fra]
      return G.from_date(fra) if fra

      G.all_history
    end

    desc 'Historikk over engangsstønad' do
      detail 'Man kan få historikk fra og med en spesifikk dato ved å spesifisere ?fra=<ISO 8601>'
      success model: Engangsstønad
      is_array true
    end
    params do
      optional :fra, type: Date
    end
    get :engangsstønad do
      fra = params[:fra]
      return E.from_date(fra) if fra

      E.all_history
    end
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.1.0',
                             info: {
                               title: 'API for grunnbeløp og engangsstønad',
                               description: 'G er en API-tjeneste som gir deg dagens grunnbeløp og engangsstønad'
                             },
                             produces: ['application/json']
end
