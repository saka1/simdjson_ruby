# frozen_string_literal: true

require 'mkmf'

$CXXFLAGS += ' $(optflags) $(debugflags) -std=c++1z -Wno-register '

create_makefile('simdjson/simdjson')
