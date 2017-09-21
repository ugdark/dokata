# frozen_string_literal: true

# 基底クラスに変更を加える場合はextendにまとめてる
require_relative 'extend/string'

class String
  include Dokata::Extend::String
end
