# frozen_string_literal: true

require 'date'
require 'geocoder'
require 'grape'
require 'grape-swagger'
require 'rack/cors'

require_relative 'g'
require_relative 'apihelper'

class G < Grape::API
  include APIHelper

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  desc 'Root redirecter til Swagger', hidden: true
  get do
    redirect 'api/v1/swagger_doc', permanent: true
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
    logger.info("Request for #{request.path} from #{request.location.data['ip']}")
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
