require 'rubygems'
require 'sinatra'
require 'erb'
require 'memcached'

require 'helpers'
require 'models/player'


set :public, File.dirname(__FILE__) + '/static'
$cache = Memcached.new("localhost:11211")

get '/' do
  erb :index
end

get '/new_scan' do
  playa = Player.find(get_reader)
  erb :scan
end


## admin type things

get '/admin' do
  erb :admin
end

get '/register_new_user' do
  @bad_oyster = true if params[:use_oyster]
  erb :register_user
end

post '/register_new_user' do
  begin
    playa = Player.new(get_reader)
  rescue NotOysterError
    redirect "/register_new_user?use_oyster=true"
  end
  
  playa.name = params["name"]
  playa.save!
  redirect "/register_new_user"
end