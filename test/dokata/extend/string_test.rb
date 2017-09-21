# frozen_string_literal: true

require_relative '../../test_helper'

require 'dokata/extend/string'

class String
  include Dokata::Extend::String
end

class TestStringModule < Test::Unit::TestCase
  def test_convert_utf8_to_sjis_正常系
    utf8_text = 'てすと'
    sjis_text = utf8_text.encode('Windows-31J')
    value = utf8_text.convert_utf8_to_sjis
    assert_equal sjis_text, value
  end

  def test_convert_sjis_to_utf8_正常系
    utf8_text = 'てすと'
    sjis_text = utf8_text.encode('Windows-31J')
    value = sjis_text.convert_sjis_to_utf8
    assert_equal utf8_text, value
  end

  def test_convert_utf16le_to_utf8_正常系
    utf8_text = 'てすと'
    utf16_text = utf8_text.encode(Encoding::UTF_16LE)
    value = utf16_text.convert_utf16le_to_utf8
    assert_equal utf8_text, value
  end

  def test_sjis_retrieval_正常系
    sjis_text = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}"
    normal_sjis_text = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}"
    value = sjis_text.sjis_retrieval
    assert_equal normal_sjis_text, value
  end

  def test_unicode_normalize_正常系
    normalized_text = 'デスド'
    unnormalized_text = "\u30C6\u3099\u30B9\u30C8\u3099"
    value = unnormalized_text.unicode_normalize
    assert_equal normalized_text, value
  end

  def test_replace_escape_正常系
    data = %w[Unit\\Test Unit/Test Unit:Test Unit*Test Unit?Test Unit"Test Unit<Test Unit>Test Unit|Test Unit\\Test]

    data.each do |v|
      assert_equal 'UnitTest', v.replace_escape
    end
  end

  def test_strip_to_i_正常系
    text = '¥1,234,567,890.987'
    value = text.strip_to_i
    assert_equal 1_234_567_890, value
  end
end
