
#include <string>
#include <string_view>

#include "simdjson_ruby.hpp"
#include "simdjson.h"
#include "simdjson.cpp" //TODO remove

VALUE rb_mSimdjsonRuby;

// https://github.com/lemire/simdjson/blob/352dd5e7faf3000004c6ad5852c119ce3e679939/tools/json2json.cpp#L10
void compute_dump(ParsedJson::iterator &pjh) {
    if (pjh.is_object()) {
        std::cout << "{";
        if (pjh.down()) {
            pjh.print(std::cout); // must be a string
            std::cout << ":";
            pjh.next();
            compute_dump(pjh); // let us recurse
            while (pjh.next()) {
                std::cout << ",";
                pjh.print(std::cout);
                std::cout << ":";
                pjh.next();
                compute_dump(pjh); // let us recurse
            }
            pjh.up();
        }
        std::cout << "}";
    } else if (pjh.is_array()) {
        std::cout << "[";
        if (pjh.down()) {
            compute_dump(pjh); // let us recurse
            while (pjh.next()) {
                std::cout << ",";
                compute_dump(pjh); // let us recurse
            }
            pjh.up();
        }
        std::cout << "]";
    } else {
        pjh.print(std::cout); // just print the lone value
    }
}

static VALUE make_json_hash(ParsedJson::iterator &it)
{
    if (it.is_object()) {
        VALUE hash = rb_hash_new();
        if (it.down()) {
            do {
                assert(it.is_string());
                VALUE key = rb_str_new(it.get_string(), it.get_string_length());
                it.next();
                VALUE val = make_json_hash(it);
                rb_hash_aset(hash, key, val);
            } while (it.next());
            it.up();
        }
        return hash;
    } else if (it.is_string()) {
        return rb_str_new(it.get_string(), it.get_string_length());
    } else if (it.is_array()) {
        VALUE ary = rb_ary_new();
        if (it.down()) {
            VALUE e0 = make_json_hash(it);
            rb_ary_push(ary, e0);
            while (it.next()) {
                VALUE e = make_json_hash(it);
                rb_ary_push(ary, e);
            }
            it.up();
        }
        return ary;
    } else if (it.is_integer()) {
        return LONG2NUM(it.get_integer());
    } else if (it.is_double()) {
        return DBL2NUM(it.get_double());
    } else if (it.get_type() == 'n') { //TODO replace get_type()
        return Qnil;
    } else if (it.get_type() == 't') { //TODO replace get_type()
        return Qtrue;
    } else if (it.get_type() == 'f') { //TODO replace get_type()
        return Qfalse;
    }
    rb_raise(rb_eNotImpError, "Not implemented yet.");
}

static VALUE
rb_simdjson_parse(VALUE self, VALUE arg)
{
    // replace this sample with true impl
    const std::string_view p{RSTRING_PTR(arg)};
    ParsedJson pj = build_parsed_json(p); // do the parsing
    if( ! pj.isValid() ) {
        std::cout << "not valid" << std::endl;

        return Qnil;
    } else {
        //std::cout << "valid" << std::endl;
        ParsedJson::iterator it{pj};
        //compute_dump(it);
        //std::cout << std::endl;

        // construct ruby hash
        return make_json_hash(it);
    }
}

extern "C" {

void
Init_simdjson_ruby(void)
{
  rb_mSimdjsonRuby = rb_define_module("SimdjsonRuby");
  rb_define_module_function(rb_mSimdjsonRuby, "parse", reinterpret_cast< VALUE (*) (...)>(rb_simdjson_parse), 1);
}

}

