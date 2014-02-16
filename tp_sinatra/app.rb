require 'json'
require 'bundler'
require 'sinatra'
require 'jbuilder'
require 'active_record'
require 'validates_email_format_of'

require_relative 'helpers/simple_helpers'

require_relative 'models/model_user'
require_relative 'models/model_booking'
require_relative 'models/model_resource'


ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'


get '/resources/:resource_id' do
  resource = Resource.find_by(id: params[:resource_id])

  if resource
    json = {
      name: resource.name,
      description: resource.description,
      links: [
        {
          rel: "self",
          uri: host+"/resource/"+resource.id.to_s
        },
        {
          rel: "bookings",
          uri: host+"/resource/"+resource.id.to_s+"/bookings"
        }
      ]
    }

    {resource: json}.to_json
  else
    halt 404
  end
end


get '/resources' do
  resources = Resource.all.collect{
      |resource| {
        name: resource.name,
        description: resource.description,
        links: [
          rel: "self",
          uri: host+"/resource/"+resource.id.to_s
        ]
      } 
    }

  {resources: resources}.to_json
end


