require 'mkmf'

# rubocop:disable Style/GlobalVars

$CXXFLAGS += ' -std=c++1z -mpclmul -mbmi -mbmi2 -mavx -mavx2 '

CWD = __dir__
SIMDJSON_DIR = File.join(CWD, '..', '..', 'vendor', 'simdjson')
dir_config('simdjson', "#{SIMDJSON_DIR}/singleheader", "#{SIMDJSON_DIR}/src")

# build vendor/simdjson
# TODO check availability of cmake & make (use `find_executable`)
Dir.chdir(SIMDJSON_DIR) do
  `cmake -DSIMDJSON_BUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release .`
  `make`
end

$libs = '-lsimdjson'

create_makefile('simdjson_ruby/simdjson_ruby')

# rubocop:enable Style/GlobalVars
