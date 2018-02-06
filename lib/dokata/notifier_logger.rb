# frozen_string_literal: true

require_relative 'logger/simple_logger'
require_relative 'logger/slack_notifier'

module Dokata
  # 複数のlogや通知をまとめて扱える。
  class NotifierLogger
    def initialize(**options)
      @loggers = options.fetch(:loggers, {}).values.map do |value|
        Dokata::Logger::SimpleLogger.new(value) unless value.try(:is_disable)
      end.compact

      @notices = options.fetch(:loggers, {}).values.map do |value|
        Dokata::Logger::SlackNotifier.new(value) unless value.try(:is_disable)
      end.compact
    end

    def debug(message, exception = nil)
      @loggers.each { |logger| logger.debug(message, exception) }
    end

    def info(message)
      @loggers.each { |logger| logger.info(message) }
      @notices.each { |slack| slack.good_message(message) }
    end

    def warn(message, exception = nil)
      @loggers.each { |logger| logger.warn(message, exception) }
      @notices.each { |slack| slack.warn_message(message, exception) }
    end

    def error(message, exception = nil)
      @loggers.each { |logger| logger.error(message, exception) }
      @notices.each { |slack| slack.danger_message(message, exception) }
    end
  end
end
