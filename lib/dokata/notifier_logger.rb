# frozen_string_literal: true

require_relative 'logger/simple_logger'
require_relative 'logger/slack_notifier'

require 'active_support'
require 'active_support/core_ext'

module Dokata

  # 複数のlogや通知をまとめて扱える。
  class NotifierLogger

    def initialize(config)

      # TODO: ここ簡略できるはず
      if config[:loggers].nil?
        @loggers = []
      else
        @loggers = config[:loggers].map do |key, value|
          Dokata::Logger::SimpleLogger.new(value)
        end
      end

      if config[:slacks].nil?
        @slacks = []
      else
        @slacks = config[:slacks].map do |key, value|
          Dokata::Logger::SlackNotifier.new(value)
        end
      end
    end


    def debug(message)
      @loggers.each { |logger| logger.debug(message) }
    end

    def info(message)
      @loggers.each { |logger| logger.info(message) }
      @slacks.each { |slack| slack.good_message(message) }
    end

    def warn(message)
      @loggers.each { |logger| logger.warn(message) }
      @slacks.each { |slack| slack.warn_message(message) }
    end

    def error(message)
      @loggers.each { |logger| logger.error(message) }
      @loggers.each { |logger| logger.danger_message(message) }
    end
  end
end
