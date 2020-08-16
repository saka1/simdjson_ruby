# frozen_string_literal: true

require 'mkmf'

$CXXFLAGS += ' -std=c++11 -Wno-register '

create_makefile('simdjson/simdjson')
