#!/usr/bin/env ruby
require 'bundler'
Bundler.require
require 'tkextlib/tile'

require_relative 'main_controller'
MainController.new.run
