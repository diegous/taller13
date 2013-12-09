require 'bundler'
require 'sinatra'
require 'active_record'

require_relative 'models/model_user'
require_relative 'models/model_booking'
require_relative 'models/model_resource'

#set :database, {adapter: "sqlite3", database: "db.sqlite3"}

get '/' do
  'Hello World'
end
