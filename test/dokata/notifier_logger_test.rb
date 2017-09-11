# frozen_string_literal: true

require_relative '../test_helper'

require 'dokata/notifier_logger'

class TestNotifierLogger < Test::Unit::TestCase

  sub_test_case '' do

    # なんのテストをしてるかわからなくなってるが基本動作確認
    # 実際に試すならstubをコメントアウト
    test '基本' do
      Dir.mktmpdir do |dir|
        log_file_path = "#{dir}/test.log"

        config = {
            slacks: {
                test1: {
                    token: '--',
                    cannel: 'test1',
                    level: 'info',
                    title: 'test1title',
                },
                test2: {
                    token: '--',
                    cannel: 'test2',
                    level: 'warn',
                    title: 'test2title',
                },
            },
            loggers: {
                test3: {
                    logdev: log_file_path,
                    shift_age: 'daily',
                    level: 'info',
                    max_history: 7,
                },
                fatal: {
                    logdev: log_file_path,
                    shift_age: 'daily',
                    level: 'info',
                    max_history: 90,
                },
            },
        }
        logger = Dokata::NotifierLogger.new(config)
        assert_not_nil logger
      end
    end

  end
end



