require 'grape'
require 'grape-swagger'

require_relative 'g'

class G < Grape::API
  include Grunnbeløp

  version 'v1', using: :path
  format :json
  prefix :api

  desc 'returnerer grunnbeløp'
  params do
    optional :date, type: String
  end
  get :grunnbeløp do
    Grunnbeløp::get_grunnbeløp(params[:date])
  end

  add_swagger_documentation  hide_documentation_path: true,
                             doc_version: '1.0.0',
                             info: {
                               title: 'Grunnbeløp',
                               description: 'Grunnbeløp API'
                             }
end
