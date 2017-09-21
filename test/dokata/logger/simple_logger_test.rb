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
          max_history: 0
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

    test 'error時にexceptionをdumpできるか' do
      Dir.mktmpdir do |dir|
        log_file_path = "#{dir}/test.log"
        config = {
          logdev: log_file_path,
          shift_age: 'daily',
          level: 'info',
          max_history: 0
        }

        logger = Dokata::Logger::SimpleLogger.new(config)

        begin
          raise StandardError, 'sample'
        rescue StandardError => e
          logger.error('error', e)
        end

        value = File.read(log_file_path).count('\n') >= 10
        assert_equal true, value
      end
    end

    test '標準出力できるか' do
      config = {
        logdev: 'stdout',
        level: 'info'
      }

      begin
        # 標準出力を StringIO オブジェクトにすり替える
        $stdout = StringIO.new
        logger = Dokata::Logger::SimpleLogger.new(config)
        logger.info('test')
        output = $stdout.string # 出力結果の取得
        value = output.include?('INFO')
        assert_equal true, value
      ensure
        $stdout = STDOUT # 元に戻す
      end
    end

    test '２つできるか' do
      Dir.mktmpdir do |dir|
        config = {
          logdev: "#{dir}/test.log",
          shift_age: 'daily',
          level: 'info',
          max_history: 0
        }

        logger = Dokata::Logger::SimpleLogger.new(config)

        config2 = {
          logdev: "#{dir}/test2.log",
          shift_age: 'daily',
          level: 'info',
          max_history: 0
        }

        logger2 = Dokata::Logger::SimpleLogger.new(config2)

        logger.info('test')
        logger2.info('test')
        value = File.exist?((config[:logdev]).to_s)
        assert_equal true, value
        value2 = File.exist?((config2[:logdev]).to_s)
        assert_equal true, value2
      end
    end
  end
end
