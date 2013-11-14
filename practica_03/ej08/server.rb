require 'sinatra'

get '/saludo' do
  "Hola Mundo!"
end

get '/saludo/:nombre' do
  "Hola #{params[:nombre]}!"
end
