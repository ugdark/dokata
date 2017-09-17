# frozen_string_literal: true

module Dokata
  module Counter

    # カウントする。
    # tmpフォルダに隠しファイルを作成してカウントを保持する。
    class FileCounter

      # @param [String] file_path
      def initialize(file_path)
        @file_path = file_path
      end

      # count get
      def current
        if File.exist?("#{@file_path}")
          count = 0
          File.open("#{@file_path}") do |file|
            count = file.read.to_i
          end
          count
        else
          0
        end
      end

      # count up
      def inc
        count = current
        File.open("#{@file_path}", 'w') do |file|
          file.puts(count + 1)
        end
      end

      # count clear
      def clear
        if FileTest.exist?("#{@file_path}")
          File.delete("#{@file_path}")
        end
      end

    end
  end
end