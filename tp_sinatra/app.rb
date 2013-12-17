require 'json'
require 'bundler'
require 'sinatra'
require 'active_record'
require 'validates_email_format_of'

require_relative 'models/model_user'
require_relative 'models/model_booking'
require_relative 'models/model_resource'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

 



get '/resources' do
  host = request.host_with_port.to_s
  resources = Resource.all
  processedResources = resources.collect{
      |resource| {
        name: resource.name,
        description: resource.description,
        links: [
          rel: "self",
          uri: host+"/resource/"+resource.id.to_s
        ]
      } 
    }

  {resources: processedResources}.to_json
end

get '/' do
  "hello world"+request.host_with_port.to_s
end

