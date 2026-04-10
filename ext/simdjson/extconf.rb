# frozen_string_literal: true

require 'mkmf'

$CXXFLAGS += ' -std=c++17 -Wno-register '

create_makefile('simdjson/simdjson')
