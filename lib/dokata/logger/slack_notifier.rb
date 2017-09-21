# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'slack-ruby-client'

module Dokata
  module Logger
    # slack通知をまとめてる。
    class SlackNotifier
      def initialize(config)
        @config = config
      end

      # infoに相当するslack通知
      def good_message(message)
        post_message(message, :good, :info)
      end

      # warnに相当するslack通知
      def warn_message(message)
        post_message(message, :warning, :warn)
      end

      # errorに相当するslack通知
      # TODO: Exceptionのdumpも追加予定
      def danger_message(message, exception = nil)
        if exception.present? && exception.backtrace.present?
          post_message("#{message}\n\n#{exception.backtrace.join("\n")}", :danger, :error)
        else
          post_message(message, :danger, :error)
        end
      end

      private

      def post_message(message, color, logger_level)
        if @config[:channel].present? && is_logging?(logger_level, @config[:level])
          options = {
            channel: @config[:channel],
            attachments: [{ color: color, title: @config[:title], text: message }]
          }
          slack_client = Slack::Web::Client.new(token: @config[:token])
          slack_client.chat_postMessage(options)
        end
      end

      # ログ判定
      # @param [String] 対象のlevel
      # @param [String] 設定のlevel
      # @return [Boolean] 含まれるか
      def is_logging?(logger_level, config_level)
        levels = %i[debug info warn error]
        levels.include?(config_level.to_sym) && levels.from(levels.index(config_level.to_sym)).include?(logger_level)
      end
    end
  end
end
