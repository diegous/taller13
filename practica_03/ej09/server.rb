require 'sinatra'

get '/codigo/:code' do
  @tmp = Integer(params[:code])
  erb :index
end
