#!/usr/bin/env ruby
require 'bundler'
Bundler.require
require 'tkextlib/tile'

require_relative 'app'
App.new.mainloop
