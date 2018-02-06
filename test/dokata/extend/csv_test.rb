# frozen_string_literal: true

require_relative '../../test_helper'

require 'dokata/extend/csv'

class CSVTest < Test::Unit::TestCase
  sub_test_case '正常系' do
    test 'splitできるか' do
      CSV.split("#{TEST_DATA_DIR}/sample.csv", split_size: 2)
    end
  end
end
