# frozen_string_literal: true

require 'date'
require 'grape'
require 'grape-swagger'

require_relative 'g'

class G < Grape::API
  include Grunnbeløp

  version 'v1', using: :path
  format :json
  prefix :api

  desc 'Returnerer dagens grunnbeløp' do
    detail 'Man kan også søke opp andre grunnbeløp ved å spesifisere ?dato=<ISO 8601>'
  end
  params do
    optional :dato, type: Date, coerce_with: DateTime.method(:iso8601)
  end
  get :grunnbeløp do
    dato = params[:dato] || DateTime.now
    Grunnbeløp.get(dato)
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.0.0',
                             info: {
                               title: 'Grunnbeløp',
                               description: 'Grunnbeløp API'
                             }
end
