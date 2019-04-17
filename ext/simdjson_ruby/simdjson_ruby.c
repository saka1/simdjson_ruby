#include "simdjson_ruby.h"

VALUE rb_mSimdjsonRuby;

void
Init_simdjson_ruby(void)
{
  rb_mSimdjsonRuby = rb_define_module("SimdjsonRuby");
}
