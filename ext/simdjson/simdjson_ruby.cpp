
#include <string>
#include <string_view>

#include "ruby.h"
#include "simdjson.h"

VALUE rb_mSimdjson;

VALUE rb_eSimdjsonParseError;

using namespace simdjson;

// Convert tape to Ruby's Object
static VALUE make_ruby_object(dom::element element) {
    auto t = element.type();
    if (t == dom::element_type::ARRAY) {
        VALUE ary = rb_ary_new();
        for (dom::element x : element) {
            VALUE e = make_ruby_object(x);
            rb_ary_push(ary, e);
        }
        return ary;
    } else if (t == dom::element_type::OBJECT) {
        VALUE hash = rb_hash_new();
        for (dom::key_value_pair field : dom::object(element)) {
            std::string_view view(field.key);
            VALUE k = rb_str_new(view.data(), view.size());
            VALUE v = make_ruby_object(field.value);
            rb_hash_aset(hash, k, v);
        }
        return hash;
    } else if (t == dom::element_type::INT64) {
        return LONG2NUM(element.get<int64_t>());
    } else if (t == dom::element_type::UINT64) {
        return ULONG2NUM(element.get<uint64_t>());
    } else if (t == dom::element_type::DOUBLE) {
        return DBL2NUM(double(element));
    } else if (t == dom::element_type::STRING) {
        std::string_view view(element);
        return rb_str_new(view.data(), view.size());
    } else if (t == dom::element_type::BOOL) {
        return bool(element) ? Qtrue : Qfalse;
    } else if (t == dom::element_type::NULL_VALUE) {
        return Qnil;
    }
    // unknown case (bug)
    rb_raise(rb_eException, "[BUG] must not happen");
}

static VALUE rb_simdjson_parse(VALUE self, VALUE arg) {
    Check_Type(arg, T_STRING);

    dom::parser parser;
    padded_string str(RSTRING_PTR(arg), RSTRING_LEN(arg));
    dom::element doc;
    auto error = parser.parse(str).get(doc);
    if (error == SUCCESS) {
        return make_ruby_object(doc);
    }
    // TODO better error handling
    rb_raise(rb_eSimdjsonParseError, "parse error");
    return Qnil;
}

extern "C" {

void Init_simdjson(void) {
    rb_mSimdjson = rb_define_module("Simdjson");
    rb_eSimdjsonParseError = rb_define_class_under(rb_mSimdjson, "ParseError", rb_eStandardError);
    rb_define_module_function(rb_mSimdjson, "parse", reinterpret_cast<VALUE (*)(...)>(rb_simdjson_parse), 1);
}
}
