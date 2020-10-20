# frozen_string_literal: true

require 'grape'
require 'grape-swagger'

require_relative 'g'

class G < Grape::API
  include Grunnbeløp

  version 'v1', using: :path
  format :json
  prefix :api

  desc 'Returnerer dagens grunnbeløp' do
    detail 'Man kan også søke opp andre grunnbeløp ved å spesifisere ?date=<ISO 8601>'
  end
  params do
    optional :dato, type: 'ISO 8601'
  end
  get :grunnbeløp do
    value = Grunnbeløp.get(params[:date])
    status value[:status] if value.key?(:status)
    return value
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.0.0',
                             info: {
                               title: 'Grunnbeløp',
                               description: 'Grunnbeløp API'
                             }
end
