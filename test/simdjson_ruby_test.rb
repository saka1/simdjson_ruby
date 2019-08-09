require 'test_helper'

class SimdjsonRubyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SimdjsonRuby::VERSION
  end

  def test_object_str
    x = SimdjsonRuby.parse('{"a": "xyz"}')
    assert x.is_a? Hash
    assert_equal 'xyz', x['a']
  end

  def test_object_int
    value = 123_456
    x = SimdjsonRuby.parse(%({"a": #{value}}))
    assert_equal value, x['a']
  end

  def test_array
    x = SimdjsonRuby.parse('[1, 2, 3]')
    assert_equal 3, x.size
    assert_equal [1, 2, 3], x
  end

  def test_null
    x = SimdjsonRuby.parse('[null]')
    assert_equal 1, x.size
    assert x[0].nil?
  end

  def test_double
    x = SimdjsonRuby.parse('{"a": 1.2345}')
    assert_in_delta 1.2345, x['a']
  end

  def test_bool
    x = SimdjsonRuby.parse('{"a": true, "b": false}')
    assert x['a'].is_a? TrueClass
    assert x['b'].is_a? FalseClass
  end

  def test_parse_error
    assert_raises SimdjsonRuby::ParseError do
      SimdjsonRuby.parse('xxxx')
    end
  end
end
