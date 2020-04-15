# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Zenithal

Encoding.default_external = "UTF-8"
$stdout.sync = true


whole_converter = Book::WholeBookConverter.new(ARGV)
whole_converter.execute