require 'rubygems'
require 'sinatra'
require 'erb'
require 'memcached'
require 'json'
require 'helpers'
require 'models/player'
require 'models/commodity'
require 'models/game'

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

post '/add_commodity' do
  c = Commodity.new
  @playa = Player.new(params[:player])
  @playa.score(c.score)
  @ret = "<commodities><type>#{c.kind}</type><value>#{c.score}</value></commodities>"
  erb :add_ajax, :layout => !request.xhr?
end

## admin type things

get '/admin' do
  erb :admin
end

get '/final_score' do
  @playa = Player.new(get_reader("/admin"))
  erb :score
  
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