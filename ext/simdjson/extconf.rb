# frozen_string_literal: true

require 'mkmf'

$CXXFLAGS += ' $(optflags) $(debugflags) -std=c++17 -Wno-register '

create_makefile('simdjson/simdjson')
