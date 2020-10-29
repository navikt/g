# frozen_string_literal: true

require 'date'
require 'grape'
require 'grape-swagger'

require_relative 'g'
require_relative 'apihelper'

class G < Grape::API
  include APIHelper

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
  get :grunnbelop do
    dato = params[:dato] || DateTime.now
    normalize_norwegian_letters(JSON.parse(Grunnbeløp.by_date(dato).to_json))
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.0.0',
                             info: {
                               title: 'Grunnbeløp',
                               description: 'Grunnbeløp API'
                             }
end
