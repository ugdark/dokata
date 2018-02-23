# frozen_string_literal: true

require 'logger'

module Dokata
  module Logger
    # loggerをラップしてる。
    class SimpleLogger
      def initialize(**options)
        logdev =
          case options[:logdev].downcase
          when 'stdout'
            $stdout
          when 'stderr'
            $stderr
          else
            options[:logdev]
          end

        @logger = ::Logger.new(logdev, options[:shift_age], level:options[:level])
        if options[:shift_age] == 'daily' && File.exist?(options[:logdev])
          rotation(logdev, options[:max_history])
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
        if exception.nil? == false && exception.backtrace.nil? == false
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
