# frozen_string_literal: true

# TODO:ruby 2.4.1移行なら loggerにしてbasic_loggerを削除
require_relative 'basic_logger'

module Dokata
  module Logger
    # loggerをまとめてる。
    class SimpleLogger

      def initialize(config)
        @logger = BasicLogger.new(config[:logdev], config[:shift_age])
        @logger.level = config[:level]
        rotation(config[:logdev], config[:max_history])
      end

      def debug(message)
        @logger.debug(message)
      end

      def info(message)
        @logger.info(message)
      end

      def warn(message)
        @logger.warn(message)
      end

      def error(message)
        @logger.warn(message)
      end

      private

      def rotation(file_path, max_history)
        if max_history.nil?
          return
        end

        allow_filenames = 1.upto(max_history).to_a.map { |i|
          date = Date.today.prev_day(i)
          "#{file_path}.#{date.strftime('%Y%m%d')}"
        }
        allow_filenames.unshift(file_path)
        Dir.glob("#{File.dirname(file_path)}/*").each do |target_file_path|
          unless allow_filenames.include?(target_file_path)
            File.delete(target_file_path)
          end
        end

      end
    end
  end
end


