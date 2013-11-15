require 'sinatra'

helpers do
  def now
    'plis'
  end
end

get '/uno' do
  @action_name = 'UNO'
  erb :index
end

get '/dos' do
  @action_name = 'DOS'
  erb :index
end

get '/tres' do
  @action_name = 'TRES'
  erb :index
end

