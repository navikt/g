# frozen_string_literal: true

require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run ->(_) { [200, { 'Content-Type' => 'text/html' }, ['OK']] }

require_relative 'lib/prometheus'
require_relative 'lib/api'

GAPI.compile!
run GAPI
