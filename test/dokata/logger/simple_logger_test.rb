# frozen_string_literal: true

require_relative '../../test_helper'

require 'dokata/logger/simple_logger'
require 'tmpdir'
require 'date'

class TestSimpleLogger < Test::Unit::TestCase

  sub_test_case '' do
    test '基本' do
      Dir.mktmpdir do |dir|
        log_file_path = "#{dir}/test.log"
        config = {
            logdev: log_file_path,
            shift_age: 'daily',
            level: 'info',
            max_history: 0,
        }
        logger = Dokata::Logger::SimpleLogger.new(config)
        logger.debug('debug')
        logger.info('info')
        logger.warn('warn')
        logger.error('error')

        # 1行は行頭、info,warn,errorのみ表示で４行
        # count(\n) なので最後がカウントされず3になる
        value = File.read(log_file_path).count('\n')
        assert_equal 3, value

      end
    end

    test '日付が変更されるか' do
      Dir.mktmpdir do |dir|
        log_file_path = "#{dir}/test.log"
        config = {
            logdev: log_file_path,
            shift_age: 'daily',
            level: 'info',
            max_history: 0
        }

        FileUtils.touch(log_file_path)
        atime = mtime = Date.today.prev_day(1).to_time
        File.utime(atime, mtime, log_file_path)

        # ここで日付確認が入るので。
        logger = Dokata::Logger::SimpleLogger.new(config)

        logger.info('info')
        value = File.exist?("#{log_file_path}.#{Date.today.prev_day(1).strftime('%Y%m%d')}")
        assert_equal true, value
      end
    end

    test 'rotation削除' do
      Dir.mktmpdir do |dir|
        log_file_path = "#{dir}/test.log"
        config = {
            logdev: log_file_path,
            shift_age: 'daily',
            level: 'info',
            max_history: 3
        }

        FileUtils.touch("#{log_file_path}.#{Date.today.prev_day(1).strftime('%Y%m%d')}")
        FileUtils.touch("#{log_file_path}.#{Date.today.prev_day(2).strftime('%Y%m%d')}")
        FileUtils.touch("#{log_file_path}.#{Date.today.prev_day(3).strftime('%Y%m%d')}")
        FileUtils.touch("#{log_file_path}.#{Date.today.prev_day(4).strftime('%Y%m%d')}")
        # ここで削除
        Dokata::Logger::SimpleLogger.new(config)

        value = File.exist?("#{log_file_path}.#{Date.today.prev_day(4).strftime('%Y%m%d')}")
        assert_equal false, value
      end
    end

  end
end



