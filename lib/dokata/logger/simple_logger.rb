# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

# TODO: ruby 2.4.1移行なら loggerにしてbasic_loggerを削除
require_relative 'basic_logger'

module Dokata
  module Logger
    # loggerをまとめてる。
    class SimpleLogger
      def initialize(config)
        logdev =
          case config[:logdev].downcase
          when 'stdout'
            $stdout
          when 'stderr'
            $stderr
          else
            config[:logdev]
          end

        @logger = BasicLogger.new(logdev, config[:shift_age])
        @logger.level = config[:level]
        if config[:shift_age] == 'daily' && File.exist?(config[:logdev])
          rotation(logdev, config[:max_history])
        end
      end

      def debug(message, exception = nil)
        @logger.debug(message)
        logging_exception(exception) { |ex_message| @logger.debug(ex_message) }
      end

      def info(message)
        @logger.info(message)
      end

      def warn(message, exception = nil)
        @logger.warn(message)
        logging_exception(exception) { |ex_message| @logger.warn(ex_message) }
      end

      def error(message, exception = nil)
        @logger.error(message)
        logging_exception(exception) { |ex_message| @logger.error(ex_message) }
      end

      private

      def logging_exception(exception = nil)
        if exception.present? && exception.backtrace.present?
          template = "#{exception.inspect} \n #{exception.backtrace.join("\n")}"
          yield template
        end
      end

      def rotation(file_path, max_history)
        return if max_history.nil?

        allow_filenames = 1.upto(max_history).to_a.map do |i|
          date = Date.today.prev_day(i)
          "#{file_path}.#{date.strftime('%Y%m%d')}"
        end
        Dir.glob("#{File.dirname(file_path)}/#{File.basename(file_path)}.*").each do |target_file_path|
          unless allow_filenames.include?(target_file_path)
            File.delete(target_file_path)
          end
        end
      end
    end
  end
end
