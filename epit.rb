require 'rubygems'
require 'sinatra'
require 'erb'
require 'helpers'

set :public, File.dirname(__FILE__) + '/static'

get '/' do
  erb :index
end

get '/new_scan' do
  @rv = get_reader
  erb :scan
end