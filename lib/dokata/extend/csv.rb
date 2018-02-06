# frozen_string_literal: true

require 'csv'

module Dokata
  module Extend
    module CSV
      # ファイル分割をする
      def split(path, options = {})
        split_size = options.fetch(:split_size, 2000)
        options.delete(:split_size)

        Dir.glob("#{File.dirname(path)}/#{File.basename(path, '.*')}.*#{File.extname(path)}")
           .each { |f| FileUtils.rm(f) if File.file?(f) }
        file_number = 0
        open(path, options).each_with_index do |row, i|
          file_number += 1 if i % split_size == 0
          split_file_path = "#{File.dirname(path)}/#{File.basename(path, '.*')}.#{file_number}#{File.extname(path)}"
          open(split_file_path, 'a') do |write|
            write << row
          end
        end
      end
    end
  end
end

class CSV
  extend Dokata::Extend::CSV
end
