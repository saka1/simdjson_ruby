
require 'mkmf'

$CXXFLAGS += ' -std=c++1z -Wno-register '

create_makefile('simdjson/simdjson')

