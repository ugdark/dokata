# frozen_string_literal: true

require_relative '../../test_helper'

require 'dokata/logger/slack_notifier'

class TestSimpleLogger < Test::Unit::TestCase
  sub_test_case '' do
    # testではなくexample
    # なんのテストをしてるかわからなくなってるが基本動作確認
    # 実際に試すならstubをコメントアウト
    test '基本' do
      config = {
        token: '---',
        channel: '--',
        level: 'info',
        title: 'こんばんわ'
      }
      slack = Dokata::Logger::SlackNotifier.new(config)
      stub(slack).good_message { { 'ok' => true } }
      stub(slack).warn_message { { 'ok' => true } }
      stub(slack).danger_message { { 'ok' => true } }

      good = slack.good_message('good')
      assert_equal true, good['ok']
      warn = slack.warn_message('warn')
      assert_equal true, warn['ok']
      danger = slack.danger_message('danger')
      assert_equal true, danger['ok']
    end

    test 'チャンネルがないならoff' do
      config = {
        token: '--',
        channel: '', # channelを空にすると送信しない。
        level: 'info',
        title: 'こんばんわ'
      }
      slack = Dokata::Logger::SlackNotifier.new(config)
      value = slack.good_message('good')
      assert_nil value
    end
  end
end
