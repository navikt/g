#!/bin/ruby

# frozen_string_literal: true

this_year = ARGV[0].to_f
last_year = ARGV[1].to_f

per_måned = (this_year / 12).round
puts "\"grunnbeløpPerMåned\": #{per_måned},"

snitt_per_år = ((last_year / 12) * 4) + ((this_year / 12) * 8)
puts "\"gjennomsnittPerÅr\": #{snitt_per_år.to_i},"

omregnignsfaktor = (this_year / last_year).round(6)
puts "\"omregningsfaktor\": #{omregnignsfaktor},"
