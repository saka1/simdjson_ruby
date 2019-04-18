require 'mkmf'

# rubocop:disable Style/GlobalVars

$CXXFLAGS += ' -std=c++1z -mpclmul -mbmi -mbmi2 -mavx -mavx2 '
# $CFLAGS += ' -std=c++1z -mbmi -mbmi2 -mavx -mavx2 '

CWD = __dir__
# SIMDJSON_DIR = File.join(CWD, '..', '..', 'vendor', 'simdjson')
SIMDJSON_DIR = File.join(CWD, '..', '..', 'vendor', 'simdjson', 'singleheader')
dir_config('simdjson', "#{SIMDJSON_DIR}/", "#{SIMDJSON_DIR}/")

create_makefile('simdjson_ruby/simdjson_ruby')

# rubocop:enable Style/GlobalVars
#
