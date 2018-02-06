# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dokata/version'

Gem::Specification.new do |spec|
  spec.name = 'dokata'
  spec.version = Dokata::VERSION
  spec.authors = ['ugdark']
  spec.email = ['ugdark@gmail.com']

  spec.summary = '業務支援ツール'
  spec.description = 'scrapingとかawsのs3に格納とかftp接続とかそういうのライブラリ'
  spec.homepage = 'http://localhost'
  spec.license = 'MIT'

  spec.add_dependency 'slack-ruby-client'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'test-unit-rr'
  spec.add_development_dependency 'yard'
end
