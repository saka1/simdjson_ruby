require 'test_helper'

class SimdjsonTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Simdjson::VERSION
  end

  def test_object_str
    x = Simdjson.parse('{"a": "xyz"}')
    assert x.is_a? Hash
    assert_equal 'xyz', x['a']
  end

  def test_object_int
    value = 123_456
    x = Simdjson.parse(%({"a": #{value}}))
    assert_equal value, x['a']
  end

  def test_array
    x = Simdjson.parse('[1, 2, 3]')
    assert_equal 3, x.size
    assert_equal [1, 2, 3], x
  end

  def test_null
    x = Simdjson.parse('[null]')
    assert_equal 1, x.size
    assert x[0].nil?
  end

  def test_double
    x = Simdjson.parse('{"a": 1.2345}')
    assert_in_delta 1.2345, x['a']
  end

  def test_bool
    x = Simdjson.parse('{"a": true, "b": false}')
    assert x['a'].is_a? TrueClass
    assert x['b'].is_a? FalseClass
  end

  def test_parse_error
    assert_raises Simdjson::ParseError do
      Simdjson.parse('xxxx')
    end
  end

  def test_parse_non_string
    assert_raises TypeError do
      Simdjson.parse(123)
    end
  end

  def test_non_utf8_string
    [Encoding::UTF_16LE, Encoding::SJIS, Encoding::EUC_JP].each do |enc|
      src = 'あああ'.encode(enc)
      assert_raises Simdjson::ParseError do
        Simdjson.parse(src)
      end
    end
  end
end
