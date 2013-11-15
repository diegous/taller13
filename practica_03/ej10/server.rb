require 'sinatra'

get '/saludo' do
  @tmp = 'Mundo'
  erb :index
end

get '/saludo/:nombre' do
  @tmp = params[:nombre]
  erb :index
end
