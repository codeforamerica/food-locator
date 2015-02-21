require 'rubygems'
require 'google/api_client'

# boot bundler
require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require 'json'

# hand over exception handling to our handlers defined below
disable :show_exceptions
disable :raise_errors
#disable :dump_errors
set :protection, :except => :json_csrf


get '/hi' do

  "Sup"

end
