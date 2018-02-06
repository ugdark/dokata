# frozen_string_literal: true

module Dokata
  module Extend
    module String
      # @return [String] 文字列(SJIS)
      def convert_utf8_to_sjis
        # SJIS に存在しない文字は、スペースに変換する
        option = { invalid: :replace, undef: :replace, replace: ' ' }
        encode(Encoding::SJIS.to_s, Encoding::UTF_8.to_s, option)
      end

      # @return [String] 文字列(UTF8)
      def convert_sjis_to_utf8
        # SJIS に存在しない文字は、スペースに変換する
        option = { invalid: :replace, undef: :replace, replace: ' ' }
        encode(Encoding::UTF_8.to_s, Encoding::SJIS.to_s, option)
      end

      # @return [String] 文字列(UTF8)
      def convert_utf16le_to_utf8
        option = { invalid: :replace, undef: :replace, replace: ' ' }
        encode(Encoding::UTF_8.to_s, Encoding::UTF_16LE.to_s, option)
      end

      # UTF-8 => SJIS => UTF-8変換時の下記エラー対応用
      # U+301C from UTF-8 to Windows-31Jなエラーがでたら使う
      # 参考URL: http://qiita.com/yugo-yamamoto/items/0c12488447cb8c2fc018
      # @return string
      def sjis_retrieval
        return nil if nil?
        str = self
        # 変換テーブル上の文字を下の文字に置換する
        from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}"
        to_chr = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}"
        # 変換テーブルから漏れた不正文字は?に変換し、さらにUTF8に戻すことで今後例外を出さないようにする
        str
          .tr(from_chr, to_chr)
          .encode('Windows-31J', 'UTF-8', invalid: :replace, undef: :replace).encode('UTF-8', 'Windows-31J')
      end

      # :TODO 使うな。廃棄予定
      # alias_method :get_normalized_string, String:unicode_normalize

      # @param [String][default:''] replace_str 置換文字列
      # @return [String] 置換後の文字列
      def replace_escape(replace_str = '')
        tr_s('\\', replace_str)
          .tr_s('/', replace_str)
          .tr_s(':', replace_str)
          .tr_s('*', replace_str)
          .tr_s('?', replace_str)
          .tr_s('"', replace_str)
          .tr_s('<', replace_str)
          .tr_s('>', replace_str)
          .tr_s('|', replace_str)
      end

      # @return [Integer] 数値
      def strip_to_i
        split('.')[0]
          .delete(',').match(/[0-9]+/)[0].to_i
      end
    end
  end
end

class String
  include Dokata::Extend::String
end
