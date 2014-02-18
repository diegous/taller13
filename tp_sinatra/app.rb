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

before do
  content_type 'application/json'
end

before '/resources/:resource_id*' do
  halt 404 unless Resource.find_by(id: params[:resource_id])
end

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

get '/resources/:resource_id/bookings' do
  if params['date'] then
    date = params['date'].to_time
    halt 400 if not date
  else
    date = Date.today + 1
  end

  limit = params['limit'] ? params['limit'].to_i : 30
  halt 400 if limit > 365

  status = params['status'] ? params['status'] : 'approved'
  halt 400 if not (['approved', 'pending', 'all'].include? status)

  all_bookings = Booking.bookings_between(date, (date + limit))

  bookings = all_bookings.select { |b|
    b.resource_id == params[:resource_id].to_i &&
    status == 'all'? true : b.status == status 
  }

  my_uri = "/resources/#{params[:resource_id]}/bookings/"

  hash_bookings = bookings.collect {|b| 
    {
      start:  st_time(b.start_time),
      end:    st_time(b.end_time),
      status: b.status,
      user:   (User.find_by(id: b.user_id)).email,
      links: [
        make_link('self', my_uri + b.id.to_s),
        make_link('resource', "/resources/#{b.resource_id}"),
        make_link('accept', my_uri + b.id.to_s,'PUT'),
        make_link('reject', my_uri + b.id.to_s,'DELETE'),
      ]
    }
  }


  {
    bookings: hash_bookings,
    links: [
      make_link('self', "/resources/#{params[:resource_id]}/bookings?date=#{date.to_date}&limit=#{limit}&status=#{status}")
    ]
  }.to_json
end


get '/resources/:resource_id/availability' do
  if params['date'] then
    date = params['date'].to_date
    halt 400 if not date
  else
    halt 400 
  end

  if params['limit'] then
    limit = params['limit'].to_i
    halt 400 if not limit
  else
    halt 400
  end

  resource = Resource.find_by(id: params[:resource_id])

  myHash = resource.availability(st_time(date), st_time(date + limit)).map {|s|
    s.merge(links: [
        {
          rel: 'book', 
          link: host+"/resources/#{resource.id}/bookings",
          method: 'POST'
        },
        make_link('resource', "/resources/#{resource.id}")

      ]
    )
  }

  {
    availability: myHash,
    links: [
      {
        rel: 'self', 
        link: host+"/resources/#{resource.id}/availability?date=#{params['date']}&limit=#{limit}"
      }
    ]
  }.to_json

end

post '/resources/:resource_id/bookings' do
  if (from = params['from']) && from.to_time then
    from = st_time(from)
  else
    halt 400 
  end

  if (to = params['to']) && to.to_time then
    to = st_time(to)
  else
    halt 400 
  end

  r_id = params[:resource_id]

  book = Booking.bookings_between(from, to).where(resource_id: r_id)

  halt 409 unless book

  booking = Booking.create(
    resource: Resource.find_by(id: r_id),
    start_time: from,
    end_time: to,
    status: 'pending'
  )

  status 201

  pattern = {
    book:
    {
      from: from,
      to: to,
      status: 'pending',
      links: [
        {
          rel: "self",
          url: host+"/resources/#{r_id}/bookings/#{booking.id}",
        },
        {
          rel: "accept",
          uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
          method: 'PUT'
        },
        {
          rel: "reject",
          uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
          method: 'DELETE'
        }
      ]
    }
  }.to_json
end

delete '/resources/:resource_id/bookings/:booking_id' do
  booking = Booking.find_by(id: params[:booking_id])

  halt 404 unless booking

  booking.destroy

  nil
end

put '/resources/:resource_id/bookings/:booking_id' do
  booking = Booking.find_by(id: params[:booking_id])
  halt 404 unless booking
  
  r_id = params[:resource_id]
  halt 409 if Booking.bookings_between(booking.start_time.to_time,booking.end_time.to_time).where("resource_id=#{r_id} AND id!=#{booking.id}").to_a != []

  booking.status = 'approved'
  booking.save

  {
    book:
    {
      from: st_time(booking.start_time),
      to: st_time(booking.end_time),
      status: "apporved",
      links: [
        {
          rel: "self",
          url: host+"/resources/#{r_id}/bookings/#{booking.id}"
        },
        {
          rel: "accept",
          uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
          method: "PUT"
        },
        {
          rel: "reject",
          uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
          method: "DELETE"
        },
        {
          rel: "resource",
          url: host+"/resources/#{r_id}"
        }
      ]
    }
  }.to_json
end

get '/resources/:resource_id/bookings/:booking_id' do
  booking = Booking.find_by(id: params[:booking_id])
  halt 404 unless booking

  r_id = params[:resource_id]

  {
    from: st_time(booking.start_time),
    to: st_time(booking.end_time),
    status: booking.status,
    links: [
      {
        rel: "self",
        url: host+"/resources/#{r_id}/bookings/#{booking.id}"
      },
      {
        rel: "resource",
        uri: host+"/resource/#{r_id}"
      },
      {
        rel: "accept",
        uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
        method: "PUT"
      },
      {
        rel: "reject",
        uri: host+"/resource/#{r_id}/bookings/#{booking.id}",
        method: "DELETE"
      },
    ]
  }.to_json
end

