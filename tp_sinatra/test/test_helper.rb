ENV['RACK_ENV'] = 'test'

require 'bundler'
require 'sinatra'
require 'test/unit'
require 'rack/test'
require 'active_record'
require 'minitest/autorun' 
require 'database_cleaner'
require 'json_expressions/minitest'
require 'validates_email_format_of'

require File.expand_path '../../app', __FILE__
require File.expand_path '../../models/model_user', __FILE__
require File.expand_path '../../models/model_booking', __FILE__
require File.expand_path '../../models/model_resource', __FILE__

