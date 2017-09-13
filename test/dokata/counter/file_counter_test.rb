# frozen_string_literal: true

require_relative '../../test_helper'

require 'dokata/counter/file_counter'
require 'tmpdir'

class TestFilreCounter < Test::Unit::TestCase

  sub_test_case '' do
    test '基本' do
      Dir.mktmpdir do |dir|
        file_path = "#{dir}/.count"
        counter = Dokata::Counter::FileCounter.new(file_path)

        counter.inc
        counter.inc
        counter.inc
        value = counter.current
        assert_equal 3, value

      end
    end

  end
end



