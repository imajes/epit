require 'rubygems'
require 'sinatra'
require 'erb'
require 'memcached'

require 'helpers'
require 'models/player'

set :public, File.dirname(__FILE__) + '/static'
$cache = Memcached.new("localhost:11211")
$players = [] # globally accessible list of player uids

get '/' do
  @no_tag = true if params[:no_tag]
  erb :index
end

## main game opts

get '/new_scan' do
  @playa = Player.new(get_reader("/"))
  erb :scan
end

## admin type things

get '/admin' do
  erb :admin
end

get '/register_new_user' do
  @no_tag = true if params[:no_tag]
  @bad_oyster = true if params[:use_oyster]
  erb :register_user
end

post '/register_new_user' do
  begin
    playa = Player.new(get_reader("/register_new_user"))
  rescue NotOysterError
    redirect "/register_new_user?use_oyster=true"
  end
  
  playa.name = params["name"]
  playa.save!
  redirect "/register_new_user"
end