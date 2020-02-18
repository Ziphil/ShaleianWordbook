# coding: utf-8


require 'bundler/setup'
Bundler.require

include Zenithal
include Zenithal::Book

Encoding.default_external = "UTF-8"
$stdout.sync = true


whole_converter = WholeBookConverter.new(ARGV)
whole_converter.execute