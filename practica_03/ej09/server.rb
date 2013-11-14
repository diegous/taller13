require 'sinatra'

get '/codigo/:code' do
  Integer(params[:code])
end
