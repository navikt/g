# frozen_string_literal: true

require 'date'
require 'geocoder'
require 'grape'
require 'grape_logging'
require 'grape-swagger'
require 'rack/cors'

require_relative 'g'
require_relative 'apihelper'

class G < Grape::API
  include APIHelper

  logger.formatter = GrapeLogging::Formatters::Logstash.new
  insert_before Grape::Middleware::Error, GrapeLogging::Middleware::RequestLogger, { logger: logger }

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
    g = Grunnbeløp.today
    "G er en tjeneste som gir deg dagens grunnbeløp.

Grunnbeløp (#{g[:dato]}): #{g[:grunnbeløp]}
Swagger: https://g.nav.no/api/v1/swagger_doc
På NAV.no: https://www.nav.no/no/nav-og-samfunn/kontakt-nav/utbetalinger/grunnbelopet-i-folketrygden
Github: https://github.com/navikt/g
Felles datakatalog: https://data.norge.no/dataservices/27f14a5e-762a-32d7-9cef-05f2e6939cc1
"
  end

  version 'v1', using: :path
  format :json
  prefix :api

  helpers do
    params :grunnbeløp do
      optional :dato, type: Date, coerce_with: DateTime.method(:iso8601)
    end

    def logger
      G.logger
    end
  end

  before do
    if request.path.start_with?('/api/v1/grunn') && request&.location&.data
      logger.info("Request for #{request.path} from #{request.location.data['ip']}")
    end
  end

  desc 'Returnerer dagens grunnbeløp' do
    detail 'Man kan også søke opp andre grunnbeløp ved å spesifisere ?dato=<ISO 8601>'
  end
  params do
    use :grunnbeløp
  end
  get :grunnbeløp do
    dato = params[:dato] || DateTime.now
    Grunnbeløp.by_date(dato)
  end

  desc 'Returnerer dagens grunnbeløp' do
    detail 'Man kan også søke opp andre grunnbeløp ved å spesifisere ?dato=<ISO 8601>'
  end
  params do
    use :grunnbeløp
  end
  get :grunnbeloep do
    dato = params[:dato] || DateTime.now
    JSON.parse(APIHelper.normalize_norwegian_letters(Grunnbeløp.by_date(dato).to_json))
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.0.0',
                             info: {
                               title: 'Grunnbeløp',
                               description: 'Grunnbeløp API'
                             }
end
