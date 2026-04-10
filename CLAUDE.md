# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

simdjson_ruby is a Ruby C extension gem wrapping the [simdjson](https://github.com/simdjson/simdjson) high-performance JSON parser. The core is ~73 lines of C++ that converts simdjson DOM elements to Ruby objects.

## Build & Test Commands

```bash
bundle install                  # Install dependencies
bundle exec rake                # Full cycle: clobber → compile → test (default task)
bundle exec rake compile        # Compile C extension only (copies vendored simdjson first)
bundle exec rake test           # Run minitest suite
bundle exec rake bench          # Run benchmark comparisons (simdjson vs Oj vs JSON)
bundle exec rubocop             # Lint Ruby code
```

Run a single test:
```bash
bundle exec ruby -Ilib -Itest test/simdjson_test.rb --name test_object_str
```

## Architecture

- **`ext/simdjson/simdjson_ruby.cpp`** — The entire C extension. Defines `Simdjson` module with `parse` method and `Simdjson::ParseError` exception. The `make_ruby_object()` function recursively converts simdjson DOM types (ARRAY, OBJECT, INT64, UINT64, DOUBLE, STRING, BOOL, NULL_VALUE) to Ruby equivalents. **Important:** `simdjson.h` must be included before `ruby.h` — Ruby's `subst.h` redefines `snprintf` which breaks `std::snprintf` in simdjson.
- **`ext/simdjson/extconf.rb`** — mkmf config. Compiles with `-std=c++17 -Wno-register`.
- **`lib/simdjson.rb`** / **`lib/simdjson/version.rb`** — Ruby entry point and version constant.
- **`vendor/simdjson/`** — Git submodule of the upstream simdjson library. The `before_compile` rake task copies `simdjson.h` and `simdjson.cpp` from `vendor/simdjson/singleheader/` into `ext/simdjson/` before compilation. These copied files are gitignored.

## Code Style

- C++: `clang-format -style=file -i ext/simdjson/*` (Google-based, 120 col, 4-space indent)
- Ruby: RuboCop with target Ruby 3.2, 120 char line limit

## Key Details

- Requires checkout with git submodules (`git clone --recurse-submodules` or `git submodule update --init`)
- CI tests against Ruby 3.2, 3.3, 3.4, 4.0
- No runtime gem dependencies — only the vendored simdjson C++ library
