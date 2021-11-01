require 'date'
require 'prometheus/client'

require_relative 'g'

grunnbeløp_gauge = Prometheus::Client::Gauge.new(:grunnbeloep, docstring: 'Dagens grunnbeloep')
grunnbeløp_gauge.set(Grunnbeløp.by_date(DateTime.now)[:grunnbeløp])

prometheus = Prometheus::Client.registry
prometheus.register(grunnbeløp_gauge)
